#include <QCoreApplication>
#include <QLibrary>
#include <QMetaObject>
#include <QThread>

class Thread : public QThread
{
    Q_OBJECT

    QLibrary *m_lib;

public:
    Thread()
        : m_lib(0)
    {}
    ~Thread()
    {
        delete m_lib;
    }

Q_SIGNALS:
    void libraryLoaded();

public Q_SLOTS:
    void printStrings()
    {
        // NB: this will run on the *main* event loop.
        QFunctionPointer print_strings = m_lib->resolve("print_strings");
        if (print_strings) {
            print_strings();
        } else {
            qFatal("Could not resolve print_strings: %s", m_lib->errorString().toUtf8().data());
        }

        QCoreApplication::instance()->quit();
    }
protected:
    void run()
    {
        m_lib = new QLibrary(MODULE_PATH);

        if (!m_lib->load()) {
            qFatal("Could not load module: %s", m_lib->errorString().toUtf8().data());
        }

        // Queue a call to printStrings() on the main event loop (giving the
        // translations a chance to be loaded).
        QMetaObject::invokeMethod(this, "printStrings", Qt::QueuedConnection);
    }
};

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);

    Thread thread;

    // Start the thread *after* QCoreApplication is started (otherwise the
    // plugin's startup function won't be run on the Thread, and we won't test
    // what we wanted to test).
    QMetaObject::invokeMethod(&thread, "start", Qt::QueuedConnection);

    app.exec();

    return 0;
}

#include "tr_thread_test.moc"
