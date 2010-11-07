Return-Path: <bvanassche@acm.org>
MIME-Version: 1.0
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 7 Nov 2010 03:02:41 -0700
Subject: Re: RFC: Data pattern buffer filling race condition fix
Message-ID: <201011071102.41419.bvanassche@acm.org>
References: <201011061035.18709.bvanassche@acm.org>
In-Reply-To: <201011061035.18709.bvanassche@acm.org>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <JAxboe@fusionio.com>, Radha Ramachandran <radha@google.com>
List-ID: <fio@vger.kernel.org>

On Saturday 06 November 2010 10:35:18 Bart Van Assche wrote:
> On multicore non-x86 CPUs fio has been observed to frequently reports fal=
se
> data verification failures with I/O engine libaio and I/O depths above on=
e.
> This is because of a race condition in the function fill_pattern(). The c=
ode
> in that function only works correct if all CPUs of a multicore system
> observe store instructions in the order they were issued. That is the cas=
e for
> multicore x86 systems but not for all other CPU families, such as e.g. th=
e
> POWER CPU family.

Note: more information about the x86 and PowerPC memory consistency models =
can be found here:
[1] Scott Owens, Susmit Sarkar, Peter Sewell, A Better x86 Memory Model: x8=
6-TSO, Proceedings of the 22nd International Conference on Theorem Proving =
in Higher Order Logics, 2009, http://portal.acm.org/citation.cfm?id=3D16161=
07.
[2] Power Instruction Set  Architecture Version 2.06 Revision B, July 23, 2=
010, http://www.power.org.

A quote from [2]:
<quote>
The order in which the processor performs storage accesses, the order in wh=
ich
those accesses are performed with respect to another processor or mechanism=
,
and the order in which those accesses are performed in main storage may all=
 be
different.
</quote>

