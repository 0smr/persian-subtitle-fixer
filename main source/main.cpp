#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include "encodinghandler.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    app.setOrganizationName("smr");
    app.setOrganizationDomain("smr67.github.io");

    app.setWindowIcon(QIcon(":/res/resources/sub_fixer.ico"));

    qmlRegisterType<encodingHandler>("io.encode.handler",1,0,"EncodeHandler");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
