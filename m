Return-Path: <tirea@google.com>
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Thu, 2 Feb 2012 12:11:43 -0700
Subject: Re: [PATCH] Optimize pattern filling by limiting small calls to
 memcpy.
Message-ID: 
 <CAAUT-yMkot3gGYA13bwbakmMArsHYnF_bYOFNzW9sHDL2Eg+rA@mail.gmail.com>
References: 
 <CAAUT-yOCgVD61WtQB4CtY86zzYFCBfN4G=F=QCd4kvqFb4zx+Q@mail.gmail.com>
 <4F2A4DE7.7020409@fusionio.com>
In-Reply-To: <4F2A4DE7.7020409@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

No, that's actually all of it; it's really that simple.  It just takes
the pattern buffer, and replicates it until it it is at least half
full, which during verification drastically reduces the number of
calls to memcpy() for short multibyte patterns.

On Thu, Feb 2, 2012 at 12:48 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 02/02/2012 02:39 AM, Steven Lang wrote:
>> In looking at profiling the speed of fill_pattern(), it calls memcpy()
>> for the fill pattern repeatedly for multibyte patterns. =A0So for a 4
>> byte pattern with 8k IO, it calls memcpy() 2048 times.
>>
>> Since there is already 512 bytes reserved for the pattern, I figured a
>> simple solution was to use it. =A0This patch replicates short patterns
>> so they can be more efficiently copied. =A0(Single byte patterns are
>> left alone since they can make use of the much more efficient memset()
>> call.)
>>
>> The result is a 10x performance improvement on pattern filling. =A0(With
>> this patch, it's still 3x slower than when it re-uses the already
>> filled pattern.)
>>
>> ---
>> =A0options.c | =A0 =A04 ++++
>> =A01 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/options.c b/options.c
>> index f9bd1a4..b6989d4 100644
>> --- a/options.c
>> +++ b/options.c
>> @@ -689,6 +689,10 @@ static int str_verify_pattern_cb(void *data,
>> const char *input)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> + =A0 =A0 while (i > 1 && i * 2 <=3D MAX_PATTERN_SIZE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&td->o.verify_pattern[i], &td->o.verify=
_pattern[0], i);
>> + =A0 =A0 =A0 =A0 =A0 =A0 i *=3D 2;
>> + =A0 =A0 }
>> =A0 =A0 =A0 td->o.verify_pattern_bytes =3D i;
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* VERIFY_META could already be set
>
> Looks like you are missing the interesting part of this patch :-)
> But the idea definitely sounds good.
>
> --
> Jens Axboe
>

