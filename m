Return-Path: <axboe@kernel.dk>
Message-ID: <533E1172.6010803@kernel.dk>
Date: Thu, 03 Apr 2014 19:57:06 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C60.8090708@kernel.dk> <533B7FC4.70700@cran.org.uk> <533DE3DC.6020605@cran.org.uk>
In-Reply-To: <533DE3DC.6020605@cran.org.uk>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: Bruce Cran <bruce@cran.org.uk>, =?ISO-8859-1?Q?S=E9bastien_Bouchex_?= =?ISO-8859-1?Q?Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, bcran@fusionio.com
List-ID: <fio@vger.kernel.org>

On 2014-04-03 16:42, Bruce Cran wrote:
>
> On 4/1/2014 9:11 PM, Bruce Cran wrote:
>>
>> On 3/12/2014 10:33 AM, Jens Axboe wrote:
>>> On 03/12/2014 09:41 AM, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrot=
e:
>>>>
>>>> fio: pid=3D5144, err=3D5/file:backend.c:768, func=3Dfull resid,
>>>> error=3DInput/output error
>>>>
>>>> random_read: (groupid=3D0, jobs=3D1): err=3D 5 (file:backend.c:768,
>>>> func=3Dfull resid, error=3DInput/output error): pid=3D5144: Wed Mar 12
>>>> 16:36:45 2014
>>> Bruce, do you know why that is?
>>>
>>
>> It appears to be because after seeking, there's 92 bytes before a
>> space in the file (i.e. it's a sparse file), and instead of filling
>> the buffer with 0's read() is for some reason returning 0.
>>
>
> I was wrong.  The problem has something to do with fil_io_buffer - and
> in particular __fill_random_buf. The io error disappears if I change the
> line:
>
> *ptr =3D seed;
> to
> *ptr =3D 1;
>
> Also, fio-2.0.15 works, while fio-2.1 doesn't.

That makes very little sense... How could the contents of the buffer=20
change the behavior?

Could you run a git bisect? Should be quick'n easy, if it's nicely=20
reproducible.

--=20
Jens Axboe


