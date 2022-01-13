Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDEEC433FE
	for <fio@archiver.kernel.org>; Thu, 13 Jan 2022 23:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbiAMXUf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 13 Jan 2022 18:20:35 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:21812 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiAMXUf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jan 2022 18:20:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642116035; x=1673652035;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=1KtSyBVvLe6FlFAtbe+yk5PbJZiP6RlKLYk6xHvduc0=;
  b=O1492dhCRMPYDJF0DkvKVj7UmzdOPCQa8MqlElN4LZIZkm7p4UEhyvSj
   BF6AKNJJzHtkS3Zxs2IMOnaJc5sDVloX0/6dn/mKtkIpi+8zhaTHfhKbY
   b+RoI810cq3n1opwF4HXQdd4kw8ivKJe1uVIZb+YZoUH5NHlbPKEAhqKA
   6Byz1lOR6tygKi5FfAfcDYlgy+aFIkLBSmjnISs/P4bN5Ci8Bgh58KtPZ
   eSkM/r7Z8zRBCpbkoKcrf1rwhoFG/x+kD0y2HiYfQPPqNGlYFnUSpCgG2
   rgzbxMLW3n4DO24Y6joQAmwYbduElhEtk0TJrA+20p6/+EF5E92auZ3u+
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,286,1635177600"; 
   d="scan'208";a="302284833"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2022 07:20:34 +0800
IronPort-SDR: G5/V2pODeMFAUzinheLGLPgX0nwaxo8cLuBjv3GESOnmXqb7Lw4jDpueMak1TG5SlSrKs4WpMA
 kt2iclYAc64QgSGIvLw2qEQ7PzxUFow3/6DyYyV1KEcvl5MlX9gNiLzLbb456EbnRxBdMymaLW
 yL5enYnijVJ49UJBBxfOwE4qgJxjzMflSLzbzRYsIT1KzO/vdHkRL9IyDSLukpYVg/77TeFPZk
 2zpxlYILyruXh0bfc2syiE/im7vlx1Vzz+Y79IPBqzfr0HCYKdwFd8BoFIBW3LmVNvZHV5IrW/
 WuB1eKW8IiUw9nAvvwkk9zGr
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 14:52:54 -0800
IronPort-SDR: SBIzarzqS8iy39DGLOnycn98WG/KEsywN18LAGeiIPdTEHmVm/CWTCgx3DD01YYlSnnDVeSja2
 32BJ/rKtAJ7ufSMc4IZubSMCQmomp0PWUj9h5J5ft7rKiH8QtwlKnBcQoCwy/Ki7XrlOacyEIq
 6YgW/0YpETCarozZ2HfMv31ODm9pMpPuXvsvU3ZBudaNpLfY3lcf7hWc0ed57r3DmYK/w0EpKY
 nBZw78t6tM63paUhdJLYVstjW1RPDkVma5FdVSxrUiGxKSdJ/vR0tIaDYA/y8QQHNXX3UwDoOd
 67U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 15:20:35 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JZgQV3hR5z1SVnx
        for <fio@vger.kernel.org>; Thu, 13 Jan 2022 15:20:34 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1642116033; x=1644708034; bh=1KtSyBVvLe6FlFAtbe+yk5PbJZiP6RlKLYk
        6xHvduc0=; b=nYbUwlVbAj8cSfD4y9UlQ+zuRGiqmkAKqbxKu4gsbtQdjU3Orap
        Oi7FKaFIlgjRqn/nMMadg7lPFLAIPBTpH/Hn6CVrAVYmwT7Fofovj4+lo296eplS
        tDF2lL2+iYfuvQlpwqKz8IljGhtIRvqTy8W9VXJ52+4gel0wGbam3Rl3NDsLK6eP
        aBilKTzbDEZUqEpuQClxwM+6bgILX5WWhYoCVU4ncqQamNi+663t24lywL4xtzKr
        sSDsN1bSwQQlQhB1s70MJOPV7xVUJNaGn5lAWdWS7Ebu76/ozN9O5oiSallzYV5u
        9v1N9IjDUHe4t9c0UCvTm+AYe20j0vWMLZQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id H964XDVWQUwe for <fio@vger.kernel.org>;
        Thu, 13 Jan 2022 15:20:33 -0800 (PST)
Received: from [10.225.163.46] (unknown [10.225.163.46])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JZgQS6BXxz1Rwrw;
        Thu, 13 Jan 2022 15:20:32 -0800 (PST)
Message-ID: <17570043-aa80-3ed1-3fd0-23eb235f0d0b@opensource.wdc.com>
Date:   Fri, 14 Jan 2022 08:20:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: FIO performance measurement between volumes
Content-Language: en-US
To:     Robert Balogh <ethrbh@gmail.com>, fio <fio@vger.kernel.org>
References: <CAA4OwwXP+YTqcGdsS6Dbi7WwCQh1HRTd=4zc=e3ytMmn8Ke=Zw@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAA4OwwXP+YTqcGdsS6Dbi7WwCQh1HRTd=4zc=e3ytMmn8Ke=Zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 1/13/22 20:47, Robert Balogh wrote:
> hello FIO experts,
>=20
> I am a beginner in FIO, and I met with a problem.
>=20
> Currently in my Ubuntu based server the "/dev/vdb1" volume is attached
> to the "/home/batman/fio/cindervolume" path. FIO job is configured
> like this
>=20
>     [global]
>     filename=3Dfio-172_20_2_13
>     directory=3D/home/batman/fio/cindervolume rw=3Drw
>     rwmixread=3D60
>     rwmixwrite=3D40
>     bs=3D4k
>     rate=3D500k
>     direct=3D1
>     numjobs=3D1
>     time_based=3D1
>     runtime=3D14d
>     verify=3Dcrc32c
>     continue_on_error=3Dall
>     group_reporting=3D1
>=20
>     [file1]
>     iodepth=3D1
>     ; -- end job file --
>=20
> FIO is started like this and works well:
>     /usr/bin/fio --size=3D10G
> --output=3D/home/batman/fio/cindervolume/fio-172_20_2_13-process.log
> /home/batman/fioApp/fio-seq-RW.job &
>=20
> FIO version I use: fio-3.25
>=20
> My next step would be to attach a 2nd volume for example "/dev/vdc" to
> "/home/batman/fio/cindervolume-2" path, and I would do performance
> measurement between the volumes. I was checking the FIO user=E2=80=99s =
guide,
> https://fio.readthedocs.io/en/latest/fio_doc.html but unfortunately I
> cannot figure out which parameter might help me to solve this topic.
>=20
> By-the-way is this possible to do with FIO? If so, could you please
> help me by giving some direction/hints?

Move the directory=3D/... option from global section into the job section
and add a job for your other volume with directory=3D again added in that
job section to point to the new volume directory. The 2 jobs will run
simultaneously targetting different volumes, unless you add "stonewall",
in which case the jobs will run one after the other.

Or you could just write another fio script for the second volume.

It is not clear if you want to run the perf tests on the 2 volumes in
parallel or one after the other.

>=20
> thanks for your help,
>=20
> /Robi


--=20
Damien Le Moal
Western Digital Research
