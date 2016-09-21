Return-Path: <ctaylor@pivot3.com>
From: Chris Taylor <ctaylor@pivot3.com>
Subject: RE: json ouput is striping the last character of the year on Windows
Date: Wed, 21 Sep 2016 15:29:35 +0000
Message-ID: <MWHPR10MB17751F015348863551B145B78CF60@MWHPR10MB1775.namprd10.prod.outlook.com>
References: <MWHPR10MB177593F557B14F7EB39730D68CF40@MWHPR10MB1775.namprd10.prod.outlook.com>
 <cc182b9b-7c30-cacd-a976-d43aba4c1eea@kernel.dk>
In-Reply-To: <cc182b9b-7c30-cacd-a976-d43aba4c1eea@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,
Yes that is the better fix and yes it does work for me.

Thanks,
Chris

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Tuesday, September 20, 2016 9:57 PM
To: Chris Taylor <ctaylor@pivot3.com>; fio@vger.kernel.org
Subject: Re: json ouput is striping the last character of the year on Windo=
ws

On 09/19/2016 03:40 PM, Chris Taylor wrote:
> On Windows the year is not correct when using JSON output.
>
>   "time" : "Mon Sep 19 17:21:45 201",
>
> diff --git a/stat.c b/stat.c
> index c9148ad..0c64333 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -1650,7 +1650,9 @@ void __show_run_stats(void)
>
>                 os_ctime_r((const time_t *) &now.tv_sec, time_buf,
>                                 sizeof(time_buf));
> -               time_buf[strlen(time_buf) - 1] =3D '\0';
> +               #if !defined(WIN32)
> +                    time_buf[strlen(time_buf) - 1] =3D '\0';
> +                #endif

It's meant to strip the \n from the buffer, looks like the windows version =
doesn't do that. The below should be a better fix, does it work for you?


diff --git a/os/windows/posix.c b/os/windows/posix.c index 5830e4c4edab..33=
88127821ac 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -250,7 +250,7 @@ char* ctime_r(const time_t *t, char *buf)

      Time_tToSystemTime(*t, &systime);
      /* We don't know how long `buf` is, but assume it's rounded up from t=
he minimum of 25 to 32 */
-    StringCchPrintfA(buf, 31, "%s %s %d %02d:%02d:%02d %04d",=20
dayOfWeek[systime.wDayOfWeek % 7], monthOfYear[(systime.wMonth - 1) % 12],
+    StringCchPrintfA(buf, 31, "%s %s %d %02d:%02d:%02d %04d\n",
dayOfWeek[systime.wDayOfWeek % 7], monthOfYear[(systime.wMonth - 1) % 12],
  										 systime.wDay, systime.wHour, systime.wMinute, systime.wSecond,=
 systime.wYear);
      return buf;
  }

--
Jens Axboe


