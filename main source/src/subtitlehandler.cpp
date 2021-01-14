#include "subtitlehandler.h"

subtitlehandler::subtitlehandler()
{
}

/*!
 * \brief subtitlehandler::localToUtf8
 * \param fileAddress
 * \param codecs
 * \abstract change file encode from \a codec to utf-8 and replace some arabic letters with persian ones.
 * \return a bytecode that contain fixed subtitle text or empty data if not.
 */
QByteArray subtitlehandler::localToUtf8(QUrl fileAddress, QList<QByteArray> codecs)//"Windows-1256"
{
    QFile file(fileAddress.toLocalFile());
    if(file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QString data{};
        QTextStream textStream(&file);
        bool hasPersianText = false;

        data = textStream.readAll();

        if(data.indexOf("سلام") != -1 ||
                data.indexOf("من") != -1 ||
                data.indexOf("می") != -1 ||
                data.indexOf("مي") != -1)
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

                if(data.indexOf("سلام") != -1 ||
                        data.indexOf("کرد") != -1 ||
                        data.indexOf("من") != -1 ||
                        data.indexOf("می") != -1 ||
                        data.indexOf("مي") != -1)
                {
                    hasPersianText = true;
                    break;
                }
            }
        }

        //if file opened, it will close.
        file.close();

        if(hasPersianText == true)
        {
            // standardize subtitle
            data.replace("ي","ی");//replace all arabic /Yudh/ with persian /Yudh/
            data.replace("ك","ک");//replace all arabic /Kaph/ with persian /Kaph/

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
 * \brief subtitlehandler::extractSubtitles
 * \param urls
 * \return a string list containing files urls.
 */
QStringList subtitlehandler::extractSubtitles(QList<QUrl> urls)
{
    QStringList subtitles;

    for(auto & url: urls)
    {
        if(url.fileName().toLower().endsWith(".srt") ||
                url.fileName().toLower().endsWith(".ass")) //subtitle common types
        {
            subtitles.push_back(url.url());
        }
    }

    return subtitles;
}

/*!
 * \brief subtitlehandler::fixSubtitles
 * \abstract fix selected subtitles
 * \param selectedSubtitles containing files url if selected or empty string if file doesn't selected
 * \return a list containing weather if a case has succeed or not
 */
QList<int> subtitlehandler::fixSubtitles(QList<QUrl> selectedSubtitles)
{
    QList<int> states{};
    for(const auto & sub : selectedSubtitles )
    {
        if(!sub.isEmpty() && sub.isValid())
        {
            QByteArray content = localToUtf8(sub,QList<QByteArray>({"Windows-1256","ISO 8859-6"}));
            validateSubtitle(content);
            QFile file(sub.toLocalFile());

            if(file.open(QIODevice::WriteOnly | QIODevice::Text) && content.length() > 1)
            {
                file.resize(0);
                file.write(content);

                file.close();
                states.push_back(1);
            }
            else
            {
                //if can't open file for writing or there is no content to write into file.
                states.push_back(2);
            }
        }
        else
        {
            states.push_back(0);//represent no changes.
        }
    }
    return states;
}

QString subtitlehandler::tempFolderPath() const
{
    return mTempFolderPath;
}

void subtitlehandler::setTempFolderPath(QString tempFolderPath)
{
    if (mTempFolderPath == tempFolderPath)
        return;

    mTempFolderPath = tempFolderPath;
    emit tempFolderPathChanged(mTempFolderPath);
}

QString subtitlehandler::setDesktopPathToTempPath()
{
    setTempFolderPath(QStandardPaths::writableLocation(QStandardPaths::DesktopLocation));
    return tempFolderPath();
}
