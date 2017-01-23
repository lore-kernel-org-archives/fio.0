Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37617 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdAWUU6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 15:20:58 -0500
Received: by mail-wm0-f54.google.com with SMTP id c206so175132445wme.0
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 12:20:57 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
 <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
 <CANvN+emM2xeKtEgVofOyKri6WBtjqc_o1LMT8Sfawb_RMRXT0g@mail.gmail.com>
 <4b7ca744-9b23-5f55-b3f7-354aa618288a@gmail.com>
 <CANvN+e=ityWtQj_TJ3yZgTM7mr17VB=3OeyQEEQvdb5tR5AGLA@mail.gmail.com>
 <CANvN+emUGQ=voye=E6g4jFRxbp5eS8cGVJb3vTSn-bD5Db2Ycw@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <f6c73185-beae-604b-5fa7-0a66a582a41e@gmail.com>
Date: Mon, 23 Jan 2017 21:20:55 +0100
MIME-Version: 1.0
In-Reply-To: <CANvN+emUGQ=voye=E6g4jFRxbp5eS8cGVJb3vTSn-bD5Db2Ycw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org

> Are the CPU load numbers reported by FIO reliable?
>
>
> Yes, they're quite solid, just keep in mind that cpu is being reported on a
> thread basis.


Ahhh =)

That explains that

http://picpaste.com/pics/Bildschirmfoto_vom_2017-01-23_21-15-59-MEHOP3ZW.1485202585.png

Which is engine=psync on MD

and

http://picpaste.com/pics/Bildschirmfoto_vom_2017-01-23_21-19-56-9ieRvRZy.1485202817.png

which is engine=libaio on MD

--

Ha. And I thought for a second the machine is now going into "full magic 
mode" ;)

Thanks,
Tobias

