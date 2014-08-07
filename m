Return-Path: <bruce@cran.org.uk>
Message-ID: <53E40624.7040404@cran.org.uk>
Date: Thu, 07 Aug 2014 17:05:08 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: Run FIO on a Windows Partition
References: <9E26C6259ACF1842A4815F929194EDD394C42014@phex01.corp.bitmicro.com> <53E3EF6E.5050307@kernel.dk>
In-Reply-To: <53E3EF6E.5050307@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/7/2014 3:28 PM, Jens Axboe wrote:
> On 08/03/2014 06:12 PM, Ritchie Babaylan wrote:
>> I am just curios if FIO can test a Windows partition, say F: as the assigned drive letter.
>> What would be the correct syntax do I need to put on a "filename" parameter?
>> Do I need to use the "directory" parameter instead?

Specifying F: (or F:\) would test the filesystem, not the partition. I'm 
not aware of any way to easily test the area of disk on which the 
partition resides - you'd need to test the disk \\.\PhysicalDriveX and 
seek to the starting sector.  However, Windows prevents writes to areas 
of a disk which contains filesystems, so you would only be able to read 
and not write.

-- 
Bruce

