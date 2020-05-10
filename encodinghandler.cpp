#include "encodinghandler.h"

encodingHandler::encodingHandler()
{
}

/*!
 * \brief encodingHandler::localToUtf8
 * \param fileAddress
 * \param codecs
 * \abstract change file encode from \a codec to utf-8 and replace some arabic letters with persian ones.
 * \return a bytecode that contain fixed subtitle text or empty data if not.
 */
QByteArray encodingHandler::localToUtf8(QUrl fileAddress, QList<QByteArray> codecs)//"Windows-1256"
{
    QFile file(fileAddress.toLocalFile());
    if(file.open(QIODevice::ReadOnly))
    {
        QTextStream textStream(&file);
        QString data = textStream.readAll();
        bool hasPersianText = false;

        if(data.indexOf("سلام") != -1 ||  data.indexOf("من") != -1 ||  data.indexOf("می") != -1)
        {
            hasPersianText = true;
        }
        else
        {
            for(const auto & codec : codecs)
            {
                textStream.seek(0);
                textStream.setCodec(QTextCodec::codecForName(codec));
                data = textStream.readAll();

                if(data.indexOf("سلام") != -1 ||  data.indexOf("من") != -1 ||  data.indexOf("می") != -1)
                {
                    hasPersianText = true;
                    break;
                }
            }
        }

        if(hasPersianText == true)
        {
            // standardize subtitle
            data.replace("ي","ی");//replace all arabic /Yudh/ with persian /Yudh/
            data.replace("ك","ک");//replace all arabic /Kaph/ with persian /Kaph/

            file.close();

            return data.toUtf8();
        }
        else
        {
            return "";
        }
    }
    return "";
}


/*!
 * \brief encodingHandler::writeData
 * \param indexList
 * \return true if write data was successfull or false if not.
 */
bool encodingHandler::writeData(QList<qreal> indexList)
{
    bool succeed = true;
    for(const auto & i : indexList)
    {
        QFile file(mSubtitleUrls[static_cast<int>(i)]);

        file.resize(0);
        file.open(QIODevice::ReadWrite);

        file.write(mFixedContents[static_cast<int>(i)]);
    }

    return succeed;
}

/*!
 * \brief encodingHandler::extractSubtitles
 * \param urls
 * \return a string list containing files urls.
 */
QStringList encodingHandler::extractSubtitles(QList<QUrl> urls)
{
    QStringList subtitles;

    for(auto & url: urls)
    {
        if(url.path().endsWith(".srt") || url.path().endsWith(".ass"))//subtitle common types
        {
            subtitles.push_back(url.url());
        }
    }

    return subtitles;
}

/*!
 * \brief encodingHandler::fixSubtitles
 * \abstract fix selected subtitles
 * \param selectedSubtitles containing files url if selected or empty string if file doesn't selected
 * \return a list containing weather if a case has succeed or not
 */
QList<bool> encodingHandler::fixSubtitles(QList<QUrl> selectedSubtitles)
{
    QList<bool> states;
    for(const auto & sub : selectedSubtitles )
    {
        if(!sub.isEmpty() && sub.isValid())
        {
            QByteArray content = localToUtf8(sub,QList<QByteArray>({"Windows-1256","ISO 8859-6"}));
            QFile file(sub.toLocalFile());

            if(file.open(QIODevice::WriteOnly) && content.length() > 1)
            {
                file.resize(0);
                file.write(content);
                file.close();
                states.push_back(true);
            }
            else
            {
                states.push_back(false);
            }
        }
    }
    return states;
}

bool encodingHandler::fixSingleSubtitle(QUrl subtitleUrl)
{
    QByteArray content = localToUtf8(subtitleUrl,QList<QByteArray>({"Windows-1256"}));
    QFile file(subtitleUrl.url());

    if(file.open(QIODevice::ReadWrite) && content.length() > 1)
    {
        file.resize(0);
        file.write(content);
        file.close();
        return true;
    }
    return false;
}
