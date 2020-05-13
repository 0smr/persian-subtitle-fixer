#ifndef ENCODINGHANDLER_H
#define ENCODINGHANDLER_H

#include <QtQuick>
#include <QQuickItem>

#include <codecvt>
#include <locale>
#include <string>

class encodingHandler:public QQuickItem
{
    Q_OBJECT
public:
    encodingHandler();

    QByteArray localToUtf8(QUrl fileAddress,QList<QByteArray> codecs);
    Q_INVOKABLE QStringList extractSubtitles(QList<QUrl> urls);
    Q_INVOKABLE QList<int> fixSubtitles(QList<QUrl> selectedSubtitles);
signals:

public slots:

private:
    QStringList mSubtitleUrls;
    QList<QByteArray> mFixedContents;
};

#endif // ENCODINGHANDLER_H
