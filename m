Return-Path: <Vincent.Fu@sandisk.com>
From: Vincent Fu <Vincent.Fu@sandisk.com>
Subject: Re: Removing *.py ending from python script filenames
Date: Mon, 23 Jan 2017 14:47:31 +0000
Message-ID: <8697CBF0E1940C48BC792ECE899B66420D15907E@ULS-OP-MBXIP05.sdcorp.global.sandisk.com>
References: <2172844.j6hkAc7SIx@merkaba>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Return-Path: Vincent.Fu@sandisk.com
To: Martin Steigerwald <martin.steigerwald@teamix.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Mark Nelson <mnelson@redhat.com>, Ben England <bengland@redhat.com>, Karl
List-ID: <fio@vger.kernel.org>

On 2017-1-23 7:17 AM, Martin Steigerwald wrote:
> Hello Vincent, Mark, Ben, Karl, Jens,
>
> I just prepared packaging for fio-2.17 and as I added some of the new Pyt=
hon
> script I again came across the issues the file name ending "*.py" creates
> within Debian.
>
> ...
>
Martin, my ultimate intention is to provide a fio patch to eliminate the
need for fio_latency2csv.py.

The script translates latency data in fio's json+ output from the
internal data structure that fio uses into more easily understandable
latency bins and counts. I plan to prepare a patch that changes the
json+ output format to directly provide the human readable latency data
which will eliminate the need for the script.

I have no objection to any of your suggested changes.

Vincent


--
Vincent Fu
Software Dev Engr II
SanDisk, a Western Digital brand
Email: Vincent.Fu@SanDisk.com
Office: 801 987 7079


________________________________

PLEASE NOTE: The information contained in this electronic mail message is i=
ntended only for the use of the designated recipient(s) named above. If the=
 reader of this message is not the intended recipient, you are hereby notif=
ied that you have received this message in error and that any review, disse=
mination, distribution, or copying of this message is strictly prohibited. =
If you have received this communication in error, please notify the sender =
by telephone or e-mail (as shown above) immediately and destroy any and all=
 copies of this message in your possession (whether hard copies or electron=
ically stored copies).


