Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE12C352A1
	for <fio@archiver.kernel.org>; Wed, 30 Nov 2022 11:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiK3LcO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 30 Nov 2022 06:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbiK3Lbd (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Nov 2022 06:31:33 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802347CAA8
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 03:30:18 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221130113009epoutp017c148d68119fbe8280f5fcd1f95d14a5~sWVr0ZdxY0413804138epoutp01E
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 11:30:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221130113009epoutp017c148d68119fbe8280f5fcd1f95d14a5~sWVr0ZdxY0413804138epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669807809;
        bh=R6jFKa3XNsfLVbzTksm091lgTQe66qAwznxDx8KPW94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HqtOXv13bSXioEVWl1ZXHF+VOTmiqaHPBQ8f4by4WYxsyZAL8dHp4znvy0AhGD49o
         VgiwDWIOqutbtJ7pUHe9jMJ6/gAGdyegeapgpAJn5DvXt5b0JAC7oCIs/GmCNbzhJI
         +BcFxZFEQqazR3ebc0PoBr+S+XdT5C9z8iR00gXc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221130113008epcas5p2053c203cd7fc530bdfbbcf907f05dc3a~sWVro1YyK0605806058epcas5p2O;
        Wed, 30 Nov 2022 11:30:08 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NMcSb55d2z4x9Px; Wed, 30 Nov
        2022 11:30:07 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.BD.01710.7BE37836; Wed, 30 Nov 2022 20:29:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221130110217epcas5p2d43d7da1bc64aacaf03b0771d95a93b9~sV9W1xUpe3257032570epcas5p2m;
        Wed, 30 Nov 2022 11:02:17 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221130110217epsmtrp208dfba427370aa32a8cac9053834da0d~sV9W1JYru2731827318epsmtrp2u;
        Wed, 30 Nov 2022 11:02:17 +0000 (GMT)
X-AuditID: b6c32a49-c9ffa700000006ae-bd-63873eb77bf2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        21.45.14392.93837836; Wed, 30 Nov 2022 20:02:17 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221130110216epsmtip1cd245fab763e9871b1f1bcf87114c1e5~sV9V3vw2r2635026350epsmtip1g;
        Wed, 30 Nov 2022 11:02:15 +0000 (GMT)
Date:   Wed, 30 Nov 2022 16:20:53 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Vincent Fu <vincentfu@gmail.com>
Cc:     axboe@kernel.dk, fio@vger.kernel.org
Subject: Re: [PATCH 1/2] io_u: fix offset generation for mix of random and
 sequential workload
Message-ID: <20221130105053.GA20432@test-zns>
MIME-Version: 1.0
In-Reply-To: <1d29e8c8-ce79-0608-d979-d50bfbc9e112@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmuu52u/ZkgzkXpCxW3+1ns/g46wWz
        xYY2QQdmj52z7rJ7XD5b6vF5k1wAc1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
        hbmSQl5ibqqtkotPgK5bZg7QGiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmB
        XnFibnFpXrpeXmqJlaGBgZEpUGFCdkbvbraCKUoV7TelGxjXSncxcnJICJhIvNh+kLGLkYtD
        SGA3o8TFB7dYIJxPQM6M2cwQzjdGifenXzDBtFz585EJIrGXUaKn7TELSEJI4BmjxMMuPxCb
        RUBVouH4BFYQm01AW+LV2xvMILaIgIrEwQNTweqZBTQk3u7+BVYjLJAg0dHXCFbDK6Arsf/V
        AVYIW1Di5MwnQPUcHJwCthLzH0aAhEUFlCUObDsOdoOEwDl2iev/pjNDHOciMeP1CTYIW1ji
        1fEt7BC2lMTnd3uh4tkSmx7+hHqmQOLIi16oXnuJ1lP9zBC3ZUj8uPaCESIuKzH11DomiDif
        RO/vJ1C9vBI75sHYqhJ/791mgbClJW6+uwple0jsP/aPGRI+wFCcMqN+AqP8LCSvzUKyDsLW
        kViw+xPbLKCXmYFGLf/HAWFqSqzfpb+AkXUVo2RqQXFuemqxaYFhXmo5PLaT83M3MYKToJbn
        Dsa7Dz7oHWJk4mA8xCjBwawkwtvxuS1ZiDclsbIqtSg/vqg0J7X4EKMpMKomMkuJJucD03Be
        SbyhiaWBiZmZmYmlsZmhkjjv4hlayUIC6YklqdmpqQWpRTB9TBycUg1MG0K2Plm0q+Hv/OXH
        wmMslh1elmvaq7/k0Az5XqHawMiq5kOmDD9YUk/YM04PynjPyX7y8C7B8h0KGjsVPx3lZ/xu
        Lt7kWFWhssjmxrHPR6e2LqpmFObLlP15y39qkVvm1lOeJ16fmfLdpFDAetL3bmGm5+crtm3d
        fb06cLHpRReB853XoudySH5/w7YsKmpdr8kyPq9tSuvc0kIVjjj09Xw5saBOrlB6wW7rm7uT
        VoUL+H70mJMdUTnhTbrlo2kWelwnGziKrNU2fA5fJn92lqo5z6nUld3/1PjYf7MUmfEeWvo2
        IXFFrMFOhYt+UmpvJjxPPe39R2ad8xyL5QXvA8+u3vFts/Z9pdeJTh4vlViKMxINtZiLihMB
        w5pfcQsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSnK6lRXuyQfMFNovVd/vZLD7OesFs
        saFN0IHZY+esu+wel8+WenzeJBfAHMVlk5Kak1mWWqRvl8CV0fJ2G1PBJfmKPfsusjYwtkl2
        MXJySAiYSFz585EJxBYS2M0ocbG5qouRAyguLbFwfSJEibDEyn/P2bsYuYBKnjBKTFu3kxkk
        wSKgKtFwfAIriM0moC3x6u0NsLiIgIrEwQNTWUBsZgENibe7f4HVCAskSHT0NYLV8AroSux/
        dYAVYug3RomFu1axQSQEJU7OfALVrCVx499LJpCDmIEOWv6PA8TkFLCVmP8wAqRCVEBZ4sC2
        40wTGAVnIWmehaR5FkLzAkbmVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYweGrpbmD
        cfuqD3qHGJk4GA8xSnAwK4nwdnxuSxbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpi
        SWp2ampBahFMlomDU6qB6dyPD3cvme9dsrcyfIpNzpsXZxNYwlTY37zLO+DyMuN58nEznsRK
        7SPi/5NUax9PWKhjuu9jLdvluiehITOu+B19mX3teza3/+HC6t1b5Deo/73kJnbikhrvjXXf
        9I8YeDyRDj77LtHiXJRzV+LHZetE+WYdLb/UVCG8ra93wW8FY6P1oqlGxirp2o6ZAVuO6Qhc
        NJ02LVbRXLupctFJ3i07Hj/8+C3Nf4mFrOTLqiXp6tZJ0fIPjtQ7Hu1V8di/Ns37wXe7f7M8
        dc4Ez64Ku1WrGn8zLmyLsdq+wsc//p/s2D9/TpF5xIbz+f/XPJvde8R6c57Rg7IHF5RtDhx5
        rP1n/gtfkYg/Ai4J6vcWfFBiKc5INNRiLipOBABveY5BzgIAAA==
X-CMS-MailID: 20221130110217epcas5p2d43d7da1bc64aacaf03b0771d95a93b9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_8212b_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221118052633epcas5p2c19a4398ff6a9d592eadb7b93f7e5d1e
References: <20221118051454.31288-1-ankit.kumar@samsung.com>
        <CGME20221118052633epcas5p2c19a4398ff6a9d592eadb7b93f7e5d1e@epcas5p2.samsung.com>
        <20221118051454.31288-2-ankit.kumar@samsung.com>
        <1d29e8c8-ce79-0608-d979-d50bfbc9e112@gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_8212b_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Nov 28, 2022 at 04:57:28PM -0500, Vincent Fu wrote:
> On 11/18/22 00:14, Ankit Kumar wrote:
> > Sometimes while running a mix of sequential and random I/O's the
> > generated sequential offset is outside the I/O region. This usually
> > happens if the previous I/O is the last block in the region and
> > thus results in this sequential I/O's offset to be just outside the
> > region.
> > With this fix, fio generates a random offset within the I/O region.
> >
> > This fixes #1486
> >
> > Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> > ---
> >   io_u.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/io_u.c b/io_u.c
> > index 8035f4b7..e49b1b29 100644
> > --- a/io_u.c
> > +++ b/io_u.c
> > @@ -432,8 +432,11 @@ static int get_next_block(struct thread_data *td,
> struct io_u *io_u,
> >   				*is_random = false;
> >   				io_u_set(td, io_u, IO_U_F_BUSY_OK);
> >   				ret = get_next_seq_offset(td, f, ddir, &offset);
> > -				if (ret)
> > +				if (ret || offset >= f->io_size) {
> >   					ret = get_next_rand_block(td, f, ddir, &b);
> > +					offset = -1ULL;
> > +					*is_random = true;
> > +				}
> >   			}
> >   		} else {
> >   			*is_random = false;
> 
> This patch causes a regression with a workload such as:
> 
> fio --name=test --bs=4k --filesize=32k --nrfiles=10 --number_ios=10
> --file_service_type=sequential --percentage_random=50 --rw=randread
> --randrepeat=0 --ioengine=null --debug=io
> 
> Only the first file will be accessed when this patch is applied. Bad offsets
> are needed in order to trigger the move to the next file.
> 
> Here is a related issue: https://protect2.fireeye.com/v1/url?k=9f1fdb0c-fe94ce3a-9f1e5043-74fe485fffe0-0f0dbb3b9fc8b673&q=1&e=c35fdef7-d5f7-487d-b2e8-9f36779622fe&u=https%3A%2F%2Fgithub.com%2Faxboe%2Ffio%2Fissues%2F1372
> 
> Perhaps the right thing to do is to limit the offset >= f->io_size check to
> cases where nrfiles = 1 as in the patch for issue 1372.
> 
> Also, it seems to me that if we are intending to generate a sequential
> offset for this case and succeed in doing so, we should just wrap around to
> the beginning of the file instead of choosing a new random offset.
> 
> In general we have an overwhelming set of ways to generate offsets and
> little automated testing for offset generation. In the long run we should
> develop a set of tests for offset generation that exercise the different
> options. This will help us detect issues and give us confidence that future
> code changes won't introduce regressions.
> 
> Vincent
> 
Ok thanks for pointing out, adding the nrfiles == 1 check should suffice.

I thought about changing the current sequential offset generation logic but
its used for a lot of things as you pointed out. Modifying it may create
further regression.

One such case is with zone block devices when zone capacity is less than
zone size. Currently if we don't limit size by specifying io_size or
number_ios or runtime, fio will exit early without transferring size bytes
of data as it generates a bad offset i.e. offset outside the I/O region.
This is because of holes or gaps between a zone end and start of next zone.
All the test cases in t/zbd/test-zbd-support takes account of that.

There is another case with gaps ex: with workload such as "rw=read:4K"
where fio will exit early without transferring size bytes of data. I am
not sure whether this is the correct behavior.
This will only happen if file size is bigger than f->offset + f->io_size
i.e. we never reach the end of file, else it will wrap around.

I think to handle all these cases and percentage_random workload, for
multiple files is going to be tricky.

One solution I can think of is to just update the documentation for "size" by
mentioning that runtime can also get reduced if there are holes or gaps
while doing sequential I/O's, or if we have mixture of sequential or random
workload which can generate an out of I/O region offset.

Ankit





------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_8212b_
Content-Type: text/plain; charset="utf-8"


------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_8212b_--
