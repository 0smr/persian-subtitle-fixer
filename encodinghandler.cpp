#include "encodinghandler.h"

encodingHandler::encodingHandler()
{
}

QByteArray encodingHandler::localToUtf8(QUrl fileAddress, QList<QByteArray> codecs)//"Windows-1256"
{
    QFile file(fileAddress.url());

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

QStringList encodingHandler::extractSubtitles(QString urls)
{
    QStringList subtitles ,fileUrls = urls.split('\n',QString::SkipEmptyParts);

    for(auto & url: fileUrls)
    {
        if(url.endsWith(".srt"))
        {
            if(url.startsWith("file:///"))
                url.remove(0,8);// if url start with "file:///" then remove it.
            subtitles.push_back(url);
        }
    }

    return subtitles;
}

QString encodingHandler::getSample(QString content)
{
    int start = 0 , end = 0;

    start = content.indexOf("5\r\n");
    if(start == -1)
    {
        start = content.indexOf("5\n");
    }

    end = content.indexOf("\r\n",start+2);
    end = content.indexOf("\r\n",end+2);

    QStringRef y = content.midRef(start, end-start);

    return y.toString().remove("\r\n");
}

QStringList encodingHandler::fixSubtitles_test(QStringList selectedSubtitles)
{
    QStringList samples;
    for(const auto & sub : selectedSubtitles )
    {
        QByteArray content = localToUtf8(sub,QList<QByteArray>({"Windows-1256","ISO 8859-6"}));
        samples.push_back(getSample(content));

        mSubtitleUrls.push_back(sub);
        mFixedContents.push_back(content);
    }
    return samples;
}

QList<bool> encodingHandler::fixSubtitles(QStringList selectedSubtitles)
{
    QList<bool> states;
    for(const auto & sub : selectedSubtitles )
    {
        QByteArray content = localToUtf8(sub,QList<QByteArray>({"Windows-1256","ISO 8859-6"}));
        QFile file(sub);

        if(sub.length() > 1 && file.open(QIODevice::ReadWrite) && content.length() > 1)
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
    return states;
}

bool encodingHandler::fixSingleSubtitle(QString subtitleUrl)
{
    QStringList samples;

    QByteArray content = localToUtf8(subtitleUrl,QList<QByteArray>({"Windows-1256"}));
    QFile file(subtitleUrl);

    if(file.open(QIODevice::ReadWrite) && content.length() > 1)
    {
        file.resize(0);
        file.write(content);
        file.close();
        return true;
    }

    return false;
}
