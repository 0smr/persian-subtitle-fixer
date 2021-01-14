#ifndef SUBTITLEHANDLER_H
#define SUBTITLEHANDLER_H

#include <QtQuick>
#include <QQuickItem>
#include <QStandardPaths>

#include <codecvt>
#include <numeric>
#include <locale>
#include <string>

struct subStructure
{
    subStructure(): mIndex(-1),mTimeStamp(""),mContent(""){}
    long long  mIndex;
    QString mTimeStamp;
    QString mContent;
};


class subtitlehandler:public QQuickItem
{
    Q_OBJECT
    Q_CLASSINFO("Author", "SMR")
    Q_CLASSINFO("Version", "1.0.0")
    Q_PROPERTY(QString tempFolderPath READ tempFolderPath WRITE setTempFolderPath NOTIFY tempFolderPathChanged)

public:
    subtitlehandler();

    QByteArray localToUtf8(QUrl fileAddress,QList<QByteArray> codecs);
    /*!
     * \brief validateSubtitle
     * \note this function only works for ".srt" file.
     * \param subtitleContent
     * \return
     */
    QByteArray validateSubtitle(QByteArray subtitleContent)
    {
        /*!
         * \brief subIdxPattern
         * matches indexes in subtitle, i.e. 142
         */
        QRegularExpression subIdxPattern("^\\d+$");
        /*!
         * \brief subTimeStampPattern
         * matches time stamp in subtitles. i.e. 00:00:00,000 --> 11:11:11,111
         */
        QRegularExpression subTimeStampPattern("^(\\d{2}:)+\\d{2},\\d{3} --> (\\d{2}:)+\\d{2},\\d{3}$");

        QList<QByteArray> subtitleLines = subtitleContent.split('\n');

        QList<subStructure> subs;
        subStructure tempSS{};

        for(const auto & x : subtitleLines)
        {
            bool isIdx           = subIdxPattern.match(x).isValid();
            bool isTimeStamp     = subTimeStampPattern.match(x).isValid();

            if(isIdx == true && (subs.size() == 0 || x.toLongLong() > subs.last().mIndex))
                tempSS.mContent += x;
            else if(isTimeStamp == true && (subs.size() == 0 || x != subs.last().mTimeStamp))
                tempSS.mContent += x;
            else if(tempSS.mIndex != -1 || tempSS.mTimeStamp != "")
                tempSS.mContent += x;

            bool flag[3] = {tempSS.mIndex != -1,
                             tempSS.mTimeStamp.isEmpty() != true,
                             tempSS.mContent.isEmpty() != true};

            if(flag[0] && flag[1] && flag[2])
            {
                subs.push_back(tempSS);
            }
        }
        return "";
    }

    Q_INVOKABLE QStringList extractSubtitles(QList<QUrl> urls);
    Q_INVOKABLE QStringList extractSubtitles(QStringList strUrls)
    {
        QList<QUrl> urls{};
        for(const auto & x: strUrls)
            urls.push_back(x);

        return extractSubtitles(urls);
    }

    Q_INVOKABLE QList<int> fixSubtitles(QList<QUrl> selectedSubtitles);

    QString tempFolderPath() const;

signals:
    void tempFolderPathChanged(QString tempFolderPath);

public slots:
    void setTempFolderPath(QString tempFolderPath);
    QString setDesktopPathToTempPath();

private:
    QString mTempFolderPath;
    QStringList mSubtitleUrls;
    QList<QByteArray> mFixedContents;
};

#endif // SUBTITLEHANDLER_H
