#include <QCoreApplication>
#include <QTextStream>

#include <stdio.h>

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);

    QTextStream output(stdout);

    output << QCoreApplication::translate("testcontext", "test string") << ":";
    output << QCoreApplication::translate("testcontext", "test plural %n", 0, 5) << '\n';

    return 0;
}
