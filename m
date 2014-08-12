Return-Path: <Ritchie.Babaylan@bitmicro.com>
From: Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>
Subject: RE: Run FIO on a Windows Partition
Date: Tue, 12 Aug 2014 03:52:43 +0000
Message-ID: <9E26C6259ACF1842A4815F929194EDD394C4877B@phex01.corp.bitmicro.com>
References: <9E26C6259ACF1842A4815F929194EDD394C42014@phex01.corp.bitmicro.com>
 <53E3EF6E.5050307@kernel.dk> <53E40624.7040404@cran.org.uk>
In-Reply-To: <53E40624.7040404@cran.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: 'Bruce Cran' <bruce@cran.org.uk>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Thanks Bruce. I already figure it out. Below is the working config I used.

[job1]
ioengine=3Dwindowsaio
iodepth=3D4
rw=3Dwrite
filename=3D\\.\F\:


=A0
Thanks,
=A0
Ritchie Babaylan
Advance CORE Engineering
BiTMICRO Networks, Inc.


-----Original Message-----
From: Bruce Cran [mailto:bruce@cran.org.uk]=20
Sent: Friday, August 08, 2014 7:05 AM
To: Jens Axboe; Ritchie Babaylan; fio@vger.kernel.org
Subject: Re: Run FIO on a Windows Partition

On 8/7/2014 3:28 PM, Jens Axboe wrote:
> On 08/03/2014 06:12 PM, Ritchie Babaylan wrote:
>> I am just curios if FIO can test a Windows partition, say F: as the assi=
gned drive letter.
>> What would be the correct syntax do I need to put on a "filename" parame=
ter?
>> Do I need to use the "directory" parameter instead?

Specifying F: (or F:\) would test the filesystem, not the partition. I'm no=
t aware of any way to easily test the area of disk on which the partition r=
esides - you'd need to test the disk \\.\PhysicalDriveX and seek to the sta=
rting sector.  However, Windows prevents writes to areas of a disk which co=
ntains filesystems, so you would only be able to read and not write.

--
Bruce

