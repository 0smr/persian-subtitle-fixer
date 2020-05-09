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
    Q_INVOKABLE bool writeData(QList<qreal> indexList);
    Q_INVOKABLE QStringList extractSubtitles(QList<QUrl> urls);
    Q_INVOKABLE QList<bool> fixSubtitles(QStringList selectedSubtitles);
    Q_INVOKABLE bool fixSingleSubtitle(QUrl subtitleUrl);

signals:
    void invalidUrlFound(const QString &url);
    void randomSample(QString fileName, QString sampleLine);
    void errorOnRemoveBackup(QString fileUrl);

public slots:

private:
    QStringList mSubtitleUrls;
    QList<QByteArray> mFixedContents;
};

#endif // ENCODINGHANDLER_H
