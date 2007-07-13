/*  This file is part of the KDE project
    Copyright (C) 2007 Matthias Kretz <kretz@kde.org>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License version 2
    as published by the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
    02110-1301, USA.

*/

#include <QtCore/QCoreApplication>
#include <QtCore/QDateTime>
#include <QtCore/QFile>
#include <QtCore/QFileInfo>
#include <QtCore/QHash>
#include <QtCore/QProcess>
#include <QtCore/QQueue>
#include <QtCore/QRegExp>
#include <QtCore/QStringList>
#include <QtCore/QTextStream>
#include <QtCore/QtDebug>
#include <cstdlib>

class AutoMoc
{
    public:
        AutoMoc();
        ~AutoMoc();
        void run();

    private:
        void generateMoc(const QString &sourceFile, const QString &mocFileName);
        void usage(const QString &);
        void echoColor(const QString &msg)
        {
            QProcess *cmakeEcho = new QProcess;
            cmakeEcho->setProcessChannelMode(QProcess::ForwardedChannels);
            QStringList args(cmakeEchoColorArgs);
            args << msg;
            cmakeEcho->start("cmake", args, QIODevice::NotOpen);
            processes.enqueue(cmakeEcho);
        }

        QString bindir;
        QString mocExe;
        QStringList mocIncludes;
        QStringList cmakeEchoColorArgs;
        const bool verbose;
        QTextStream cerr;
        QTextStream cout;
        QQueue<QProcess *> processes;
};

void AutoMoc::usage(const QString &path)
{
    cout << "usage: " << path << " <outfile> <srcdir> <bindir> <moc executable>" << endl;
    ::exit(EXIT_FAILURE);
}

int main(int argc, char **argv)
{
    QCoreApplication app(argc, argv);
    AutoMoc().run();
    return 0;
}

AutoMoc::AutoMoc()
    : verbose(!QByteArray(getenv("VERBOSE")).isEmpty()), cerr(stderr), cout(stdout)
{
    const QByteArray colorEnv = getenv("COLOR");
    cmakeEchoColorArgs << "-E" << "cmake_echo_color" << QString("--switch=") + colorEnv << "--blue"
        << "--bold";
}

void AutoMoc::run()
{
    const QStringList args = QCoreApplication::arguments();
    Q_ASSERT(args.size() > 0);
    if (args.size() < 4) {
        usage(args[0]);
    }
    QFile outfile(args[1]);
    const QFileInfo outfileInfo(outfile);

    QString srcdir(args[2]);
    if (!srcdir.endsWith('/')) {
        srcdir += '/';
    }
    bindir = args[3];
    if (!bindir.endsWith('/')) {
        bindir += '/';
    }
    mocExe = args[4];

    QFile dotFiles(args[1] + ".files");
    dotFiles.open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray line = dotFiles.readLine();
    Q_ASSERT(line == "MOC_INCLUDES:\n");
    line = dotFiles.readLine().trimmed();
    const QStringList incPaths = QString::fromUtf8(line).split(';');
    foreach (const QString &path, incPaths) {
        mocIncludes << "-I" + path;
    }
    line = dotFiles.readLine();
    Q_ASSERT(line == "SOURCES:\n");
    line = dotFiles.readLine().trimmed();
    dotFiles.close();
    const QStringList sourceFiles = QString::fromUtf8(line).split(';');

    // the program goes through all .cpp files to see which moc files are included. It is not really
    // interesting how the moc file is named, but what file the moc is created from. Once a moc is
    // included the same moc may not be included in the _automoc.cpp file anymore. OTOH if there's a
    // header containing Q_OBJECT where no corresponding moc file is included anywhere a
    // moc_<filename>.cpp file is created and included in the _automoc.cpp file.
    QHash<QString, QString> includedMocs;    // key = moc source filepath, value = moc output filepath
    QHash<QString, QString> notIncludedMocs; // key = moc source filepath, value = moc output filename

    QRegExp mocIncludeRegExp("[\n]\\s*#\\s*include\\s+[\"<](moc_[^ \">]+\\.cpp|[^ \">]+\\.moc)[\">]");
    QRegExp qObjectRegExp("[\n]\\s*Q_OBJECT\\b");
    foreach (const QString &absFilename, sourceFiles) {
        //qDebug() << absFilename;
        const QFileInfo absFilenameInfo(absFilename);
        if (absFilename.endsWith(".cpp") || absFilename.endsWith(".cc") ||
                absFilename.endsWith(".cxx") || absFilename.endsWith(".C")) {
            //qDebug() << "check .cpp file";
            QFile sourceFile(absFilename);
            sourceFile.open(QIODevice::ReadOnly);
            const QByteArray contents = sourceFile.readAll();
            if (contents.isEmpty()) {
                cerr << "kde4automoc: empty source file: " << absFilename << endl;
                continue;
            }
            const QString contentsString = QString::fromUtf8(contents);
            const QString absPath = absFilenameInfo.absolutePath() + '/';
            Q_ASSERT(absPath.endsWith('/'));
            int matchOffset = mocIncludeRegExp.indexIn(contentsString);
            if (matchOffset < 0) {
                // no moc #include, look whether we need to create a moc from the .h nevertheless
                //qDebug() << "no moc #include in the .cpp file";
                const QString basename = absFilenameInfo.completeBaseName();
                const QString headername = absPath + basename + ".h";
                if (QFile::exists(headername) && !includedMocs.contains(headername) &&
                        !notIncludedMocs.contains(headername)) {
                    const QString currentMoc = "moc_" + basename + ".cpp";
                    QFile header(headername);
                    header.open(QIODevice::ReadOnly);
                    const QByteArray contents = header.readAll();
                    if (qObjectRegExp.indexIn(QString::fromUtf8(contents)) >= 0) {
                        //qDebug() << "header contains Q_OBJECT macro";
                        notIncludedMocs.insert(headername, currentMoc);
                    }
                }
            } else {
                do { // call this for every moc include in the file
                    const QString currentMoc = mocIncludeRegExp.cap(1);
                    //qDebug() << "found moc include: " << currentMoc << " at offset " << matchOffset;
                    QString basename = QFileInfo(currentMoc).completeBaseName();
                    const bool moc_style = currentMoc.startsWith("moc_");
                    if (moc_style || qObjectRegExp.indexIn(contentsString) < 0) {
                        if (moc_style) {
                            basename = basename.right(basename.length() - 4);
                        }
                        const QString sourceFilePath = absPath + basename + ".h";
                        if (!QFile::exists(sourceFilePath)) {
                            cerr << "kde4automoc: The file \"" << absFilename <<
                                "\" includes the moc file \"" << currentMoc << "\", but \"" <<
                                sourceFilePath << "\" does not exist." << endl;
                            ::exit(EXIT_FAILURE);
                        }
                        includedMocs.insert(sourceFilePath, currentMoc);
                        notIncludedMocs.remove(sourceFilePath);
                    } else {
                        includedMocs.insert(absFilename, currentMoc);
                        notIncludedMocs.remove(absFilename);
                    }

                    matchOffset = mocIncludeRegExp.indexIn(contentsString,
                            matchOffset + currentMoc.length());
                } while(matchOffset >= 0);
            }
        } else if (absFilename.endsWith(".h") || absFilename.endsWith(".hpp") ||
                absFilename.endsWith(".hxx") || absFilename.endsWith(".H")) {
            if (!includedMocs.contains(absFilename) && !notIncludedMocs.contains(absFilename)) {
                // if this header is not getting processed yet and is explicitly mentioned for the
                // automoc the moc is run unconditionally on the header and the resulting file is
                // included in the _automoc.cpp file (unless there's a .cpp file later on that
                // includes the moc from this header)
                const QString currentMoc = "moc_" + absFilenameInfo.completeBaseName() + ".cpp";
                notIncludedMocs.insert(absFilename, currentMoc);
            }
        } else {
            if (verbose) {
               cout << "kde4automoc: ignoring file '" << absFilename << "' with unknown suffix" << endl;
            }
        }
    }

    // run moc on all the moc's that are #included in source files
    QHash<QString, QString>::ConstIterator end = includedMocs.constEnd();
    QHash<QString, QString>::ConstIterator it = includedMocs.constBegin();
    for (; it != end; ++it) {
        generateMoc(it.key(), it.value());
    }

    // source file that includes all remaining moc files
    outfile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate);
    QTextStream outStream(&outfile);
    outStream << "/* This file is autogenerated, do not edit */\n";

    // run moc on the remaining headers and include them in the _automoc.cpp file
    end = notIncludedMocs.constEnd();
    it = notIncludedMocs.constBegin();
    for (; it != end; ++it) {
        generateMoc(it.key(), it.value());
        outStream << "#include \"" << it.value() << "\"\n";
    }
    outfile.close();
}

AutoMoc::~AutoMoc()
{
    // let all remaining moc processes finish
    while (!processes.isEmpty()) {
        QProcess *proc = processes.dequeue();
        if (!proc->waitForFinished()) {
            cerr << "kde4automoc: process failed: " << proc->errorString() << endl;
        }
        delete proc;
    }
}

void AutoMoc::generateMoc(const QString &sourceFile, const QString &mocFileName)
{
    //qDebug() << Q_FUNC_INFO << sourceFile << mocFileName;
    const QString mocFilePath = bindir + mocFileName;
    if (QFileInfo(mocFilePath).lastModified() < QFileInfo(sourceFile).lastModified()) {
        if (verbose) {
            echoColor("Generating " + mocFilePath + " from " + sourceFile);
        } else {
            echoColor("Generating " + mocFileName);
        }

        // we don't want too many child processes
        if (processes.size() > 10) {
            while (!processes.isEmpty()) {
                QProcess *proc = processes.dequeue();
                if (!proc->waitForFinished()) {
                    cerr << "kde4automoc: process failed: " << proc->errorString() << endl;
                }
                delete proc;
            }
        }

        QProcess *mocProc = new QProcess;
        mocProc->setProcessChannelMode(QProcess::ForwardedChannels);
        QStringList args(mocIncludes);
        args << "-o" << mocFilePath << sourceFile;
        //qDebug() << "executing: " << mocExe << args;
        mocProc->start(mocExe, args, QIODevice::NotOpen);
        processes.enqueue(mocProc);
    }
}
