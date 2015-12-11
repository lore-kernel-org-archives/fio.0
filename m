Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:32854 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbbLKE1y convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 10 Dec 2015 23:27:54 -0500
Received: by qgea14 with SMTP id a14so183366322qge.0
        for <fio@vger.kernel.org>; Thu, 10 Dec 2015 20:27:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DC12A894E6E89949B50B1F35C3903C1B3B3CF8B2@G4W3291.americas.hpqcorp.net>
References: <43CC9862-F6E2-46FE-879E-09A7AE2251FC@hpi.de>
	<DC12A894E6E89949B50B1F35C3903C1B3B3CF8B2@G4W3291.americas.hpqcorp.net>
Date: Thu, 10 Dec 2015 20:27:53 -0800
Message-ID: <CAKXScpXd4wVD_CmAizGygrNvAMQWac95PFk-csYPbn_zp3EuCw@mail.gmail.com>
Subject: Re: GiB vs GB
From: "danielabuggie ." <danielabuggie@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Wolford, Jeff (HP Servers - Web Scale performance)" <jeff.wolford@hpe.com>
Cc: "Boissier, Martin" <Martin.Boissier@hpi.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>

This unfortunately is a bit more confusing than considering 1kB =
1024, but rather per the man page, 1KiB = 1000 (emphasis mine):

       int    SI  integer:  a whole number, possibly containing a suffix
denoting the base unit of the value.  Accepted suffixes are ‘k’, ’M’, ’G’,
’T’, and ’P’, denoting kilo (1024), mega (1024^2), giga (1024^3), tera
(1024^4), and peta (1024^5) respectively. If prefixed with ’0x’, the value
is assumed to be base 16 (hexadecimal). A suffix may include a trailing
’b’, for instance ’kb’ is identical to ’k’....

***
You can  specify  a  base  10 value by using ’KiB’, ’MiB’,’GiB’, etc.
This is useful for disk drives where values are often given in base 10
values. Specifying ’30GiB’ will get you 30*1000^3 *bytes.
***

Adding a 'B' to specify base-10 certainly can be a point of confusion if
you didn't read through the manual or aren't paying attention.

Example:

# fio --name=test --bs=4k --size=*4GiB* --rw=read --ioengine=libaio
test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.2.10
Starting 1 process
test: Laying out IO file(s) (1 file(s) / *3814MB*)

# fio --name=test --bs=4k --size=*4GB* --rw=read --ioengine=libaio
test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.2.10
Starting 1 process
test: Laying out IO file(s) (1 file(s) / *4096MB*)

I don't know if there is a good fix for this now, as if Fio is made
compliant everyone's jobfiles will also have to be changed as well.
Maybe as a buffer add a "--si=bool" flag to use the correct units,
eventually switching the default from 0 to 1.

Daniel

On Thu, Dec 10, 2015 at 8:50 AM, Wolford, Jeff (HP Servers - Web Scale
performance) <jeff.wolford@hpe.com> wrote:
> 1) As the premiere storage performance testing tool, fio should make sure it is correct and consistent in its use of GB vs GiB
>         NET: In general all of the kB, MB, MB/s, etc fio usage needs to be displayed as KiB, MiB and MiB/s, etc
>                 (yes, notice the case difference between kB and KiB.. that is how it is defined by the IEC in 1998
>                 So it would be good to bring fio forward 17 years
>
> 2) There is no conspiracy... the memory guys got it WRONG when they used a SI term and REDEFINED it as KB = 1024
>         The Metric / SI system, Hz, Volt, Ohm... existed 100 years before the memory guys.
>                 How many Hz are in a Mega Hertz ?  How many ohms in a Mega Ohm ? etc, etc
>                 All the rest of the pieces of the computer system that use SI / Metric use 10 based definitions
>         Are IOPs in 1024 second groups ? Does the CPU use 1024^3 GHz clock ?
>
> So now this "redefinition" is known as KiB.
>
> Jeff
>
>
> | -----Original Message-----
> | From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of
> | Boissier, Martin
> | Sent: Thursday, December 10, 2015 2:00 AM
> | To: fio@vger.kernel.org
> | Subject: GiB vs GB
> |
> | Hey Aaron,
> |
> | I was just stumpling over the page for FIO and was totally surprised how GiB and
> | GB are used even denoting "Storage manufacturers like to use 10^3 or 1000 as a
> | base ten unit instead, for obvious reasons.”.
> | As FIO is a great tool to get into the whole game of block IO it’s sad that beginners
> | are confused by a wrong usage of SI standards and such (almost) "conspiracy
> | theories”. Or did I get something wrong here?
> |
> | Best,
> | Martin
