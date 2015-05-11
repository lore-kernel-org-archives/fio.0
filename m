Return-Path: <cheerios123@outlook.com>
Message-ID: <BLU406-EAS203C4EE266D87AD0F72049E0DB0@phx.gbl>
Return-Path: cheerios123@outlook.com
From: Jon Tango <cheerios123@outlook.com>
Subject: Why Seperate Log Files?
Date: Sun, 10 May 2015 20:36:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
To: 'Andrey Kuzmin' <andrey.v.kuzmin@gmail.com>
Cc: 'Jens Axboe' <axboe@kernel.dk>, 'Sitsofe Wheeler' <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

When I use fio in 2.1.8 the write_iops_log command creates a singular =
log file, even with 8 workers. With fio in the latest versions, however, =
it creates eight separate log files. Is there a way to get fio to =
generate a log file for all 8 workers, instead of 8 separate files? That =
is untenable. I had to go back to 2.1.8 to get a useable output. It's =
not like the data outputs are very friendly anyway, but with one file at =
least that data can easily be parsed and worked with. With a different =
file for each worker it is just ridiculous.=20
How do we get one output for all workers?
It would also be nice if we could just get one output with all of the =
numbers for the different workers combined, but that may be asking a bit =
much. Just getting them all in a workable file would be nice :)=20

-----Original Message-----
From: Jon Tango [mailto:cheerios123@outlook.com]=20
Sent: Tuesday, September 30, 2014 4:14 AM
To: 'Andrey Kuzmin'
Cc: 'Jens Axboe'; 'Sitsofe Wheeler'; fio@vger.kernel.org
Subject: RE: Limit LBA Range


The same thing could be done by partitioning the SSD in the operating =
system with the desired partition size, and then running a time-based =
fio job against the partition.

Basically, fio options offset/size should yield the same net result, but =
I'm always unsure on what is the actual effect of mixing size and =
time_based in a single job, and whether fio will wrap around the =
specified size to the specified offset if the job is time-based. HOWTO =
could have used some clarification on size/time_based interaction.

Regards,
Andrey

On Sep 30, 2014 11:41 AM, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
>
> On 30 September 2014 07:34, Jon Tango <cheerios123@outlook.com> wrote:
> >
> > The taskfile is this:
>
> I should have been more specific - you need to show both the _vdbench_ =

> parameter file that you are comparing to in addition to showing your=20
> fio job file.
>
> --
> Sitsofe |http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the=20
> body of a message tomajordomo@vger.kernel.org More majordomo info at=20
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe fio" in the =
body of a message to majordomo@vger.kernel.org More majordomo info at  =
http://vger.kernel.org/majordomo-info.html

I'm really wanting to avoid the filesystem, they create so much =
interference. I am focusing on just testing the raw device :)

