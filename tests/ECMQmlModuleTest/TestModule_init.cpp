#include <qglobal.h> 
#include <QDebug> 
 void initQmlResourceTestModule() {Q_INIT_RESOURCE(TestModule); qWarning()<<Q_FUNC_INFO;};