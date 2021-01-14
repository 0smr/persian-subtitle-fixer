#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

#include "subtitlehandler.h"
#include "qtsingleapplication.h"
#include "settingmodifier.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QtSingleApplication app(argc, argv);

    /// if there is other instance, so data will send to other one.
    if (app.sendMessage(app.arguments().join('\n'))) {
        return 0;
    }

    app.setOrganizationName("smr");
    app.setApplicationVersion("v1");
    app.setOrganizationDomain("smr67.github.io");
    app.setApplicationName("subtitle fixer(pr)");
    app.setWindowIcon(QIcon(":/res/resources/sub_fixer.ico"));

    qmlRegisterType<subtitlehandler>("io.subtitle.handler",1,0,"SubtitleHandler");
    qmlRegisterType<settingModifier>("io.advanced.setting",1,0,"SettingModifier");

    QQmlApplicationEngine engine;

    QStringList argvTemp = app.arguments();

    engine.rootContext()->setContextProperty("appInstance", &app);
    engine.rootContext()->setContextProperty("argv", argvTemp);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
