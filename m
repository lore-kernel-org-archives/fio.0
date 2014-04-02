Return-Path: <bruce@cran.org.uk>
Message-ID: <533B7FC4.70700@cran.org.uk>
Date: Tue, 01 Apr 2014 21:11:00 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C60.8090708@kernel.dk>
In-Reply-To: <53208C60.8090708@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, =?ISO-8859-1?Q?S=E9bastien_Bouchex_?= =?ISO-8859-1?Q?Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, bcran@fusionio.com
List-ID: <fio@vger.kernel.org>


On 3/12/2014 10:33 AM, Jens Axboe wrote:
> On 03/12/2014 09:41 AM, S=E9bastien Bouchex Bellomi=E9 wrote:
>>
>> fio: pid=3D5144, err=3D5/file:backend.c:768, func=3Dfull resid,=20
>> error=3DInput/output error
>>
>> random_read: (groupid=3D0, jobs=3D1): err=3D 5 (file:backend.c:768,=20
>> func=3Dfull resid, error=3DInput/output error): pid=3D5144: Wed Mar 12=
=20
>> 16:36:45 2014
> Bruce, do you know why that is?
>

It appears to be because after seeking, there's 92 bytes before a space=20
in the file (i.e. it's a sparse file), and instead of filling the buffer=20
with 0's read() is for some reason returning 0.

--=20
Bruce

