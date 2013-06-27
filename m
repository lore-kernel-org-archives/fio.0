Return-Path: <gschoenberger@thomas-krenn.com>
Date: Thu, 27 Jun 2013 11:31:37 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= <gschoenberger@thomas-krenn.com>
Message-ID: <755332160.231063.1372325497192.JavaMail.root@thomas-krenn.com>
In-Reply-To: <20130627090249.GM25599@kernel.dk>
Subject: Re: Pull Request for Adding 2 new tools around fio
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Erwan Velu <erwan@enovance.com>
List-ID: <fio@vger.kernel.org>

Hey there,

> > I'm been using fio for years and that's a wonderful tool. Since I'm
> > working
> > at eNovance, I'm facing situations where I shall compare servers
> > and disks
> > in a clusterized environnement.

I am also using fio for quite a time and I really like it a lot!

> > To help setting up this benchmark, I've been doing two tools :
> > - genfio to generate the fio script files
> > Details of its behavior & options can be found in the commit itself
> > (also
> > available with the -help option)
> > A single command like 'genfio -d sdb,sdc,sdd,sde -a -b 4k,128k,1m
> > -r 100'
> > generates a single fio file that will runs 60 tests on 4 disks
> > during 100
> > seconds each. That does avoid human mistake and ease
> > reproductability

These tools look really nice!

I will pick up the topic of fio tools and also introduce a tool based on fio that
is implementing a recent SNIA specification:
* Solid State Storage (SSS) Performance Test Specification (PTS)
- http://www.snia.org/tech_activities/standards/curr_standards/pts

I was looking for an open source tool implementing this specification, but I could not found one.
Therefore I have written a performance tool implementing the standard, in Python using fio:
* TKperf
- http://git.thomas-krenn.com/TKperf_v1.git/

* TKperf is starting a test for a device and generates plots and a pdf report:
- http://www.thomas-krenn.com/de/wikiDE/images/e/e5/TKperf-Report-IntelDCS3700.pdf
(a report for the recent Intel Data Center SSDs)

* More information (video, slides, wiki article)
- http://www.thomas-krenn.com/de/wiki/Event-News:_LinuxTag_2013_SSD_and_HDD_performance_testing_with_TKperf
- http://www.thomas-krenn.com/de/wiki/TKperf

> > I hope this work will have some interest for the fio project or
> > maybe some
> > other users.

My intention is also to increase the degree of popularity for fio, as it is awesome!
Regards, Georg

