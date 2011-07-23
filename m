Return-Path: <dengberg@evernote.com>
MIME-Version: 1.0
From: Dave Engberg <dengberg@evernote.com>
Date: Sat, 23 Jul 2011 13:04:24 -0600
Subject: Re: bsrange doesn't accept separate read,write values
Message-ID: <4E2B1B38.5060909@evernote.com>
References: <4E2B18C5.3090602@evernote.com> <4E2B1A16.20509@fusionio.com>
In-Reply-To: <4E2B1A16.20509@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


Yes, it appears to work for me. E.g. if I use this:
bsrange=3D512-23k,1k-42k

Then fio emits this at start-up:
job1: (g=3D0): rw=3Drandrw, bs=3D512-23K/1K-42K, ioengine=3Dsync, iodepth=
=3D1


On 7/23/11 11:59 AM, Jens Axboe wrote:
> Does this actually work, do you get the ranges set correctly? bssplit=20
> has a separate parse handler for the range.=20

