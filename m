Return-Path: <bengland@redhat.com>
Date: Fri, 27 May 2016 15:29:21 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <991224849.66548485.1464377361166.JavaMail.zimbra@redhat.com>
In-Reply-To: <57487D92.7070306@kernel.dk>
References: <1119349874.66202652.1464289871526.JavaMail.zimbra@redhat.com> <57485CF7.2070308@kernel.dk> <57487D92.7070306@kernel.dk>
Subject: Re: problem with fio --client and latency logs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Tim Wilkinson <twilkins@redhat.com>, Andrew Theurer <atheurer@redhat.com>, John Harrigan <jharriga@redhat.com>
List-ID: <fio@vger.kernel.org>

it passes my simple test, I'll try it out in the large next, thx Jens.

This is the last commit I saw in master branch upstream just now after pulling into my clone:

commit e35fb4c43ecc5b9d35cb5d980e811d3408fc5a4e
Author: Jens Axboe <axboe@fb.com>
Date:   Fri May 27 11:01:15 2016 -0600

    server: ensure that we flush compressed logs correctly
    
    Do chunkwise block compression, and flush at the end, adding more space
    as needed.
    
    Signed-off-by: Jens Axboe <axboe@fb.com>

When I run fio -h after rebuild, it shows I'm on this commit because last 4 hex digits of version "fio-2.11-5-ge35f" are first 4 digits of git commit ID, which is reassuring.


----- Original Message -----
> From: "Jens Axboe" <axboe@kernel.dk>
> To: "Ben England" <bengland@redhat.com>, fio@vger.kernel.org
> Cc: "Tim Wilkinson" <twilkins@redhat.com>, "Andrew Theurer" <atheurer@redhat.com>, "John Harrigan"
> <jharriga@redhat.com>
> Sent: Friday, May 27, 2016 1:02:10 PM
> Subject: Re: problem with fio --client and latency logs
> 
> On 05/27/2016 08:43 AM, Jens Axboe wrote:
> > On 05/26/2016 01:11 PM, Ben England wrote:
> >> recently I noticed a problem in master branch when fio --client is
> >> used.  latency logs generated with it have large numbers of "0, 0, 0,
> >> 0" records at the end of the file.  I have a simple reproducer fio
> >> jobfile:
> >>
> >> --------- reproducer.fiojob ----
> >> [global]
> >> numjobs=1
> >> directory=/var/tmp
> >>
> >> [shared-files]
> >> rw=randread
> >> write_lat_log=1thr
> >> ioengine=sync
> >> bs=4k      # I/O size
> >> filesize=1g  # file size
> >> runtime=20
> >> -------------
> >>
> >> If you run this job file like this:
> >>
> >> # fio --server --daemonize=/var/run/fiosvr.pid
> >> # fio --client=localhost reproducer.fiojob
> >>
> >> You get the latency log 1thr_clat.1.log with the 0 records at the
> >> end.  If you run the same job file with:
> >>
> >> # fio reproducer.fiojob
> >>
> >> You don't get the 0 records.  This explains why Ceph CBT does not have
> >> the problem, for example.
> >>
> >> I bisected fio history using git until I found the first commit that
> >> failed:
> >>
> >> -------
> >> commit 0cba0f919ee6af7dd65df436884336cff9c903f9
> >> Author: Jens Axboe <axboe@fb.com>
> >> Date:   Thu Dec 17 14:54:15 2015 -0700
> >>
> >>      client/server: transparent handling of storing compressed logs
> >>
> >>      Signed-off-by: Jens Axboe <axboe@fb.com>
> >> ------
> >>
> >> I could use some help figuring out what went wrong at this point, the
> >> diffs were complicated but it seemed possible that this commit was
> >> related to my problem.
> >
> > I have a good idea what this might be, I'll take a look at it.
> 
> http://git.kernel.dk/cgit/fio/commit/?id=e35fb4c43ecc5b9d35cb5d980e811d3408fc5a4e
> 
> This should fix it, can you try with current -git?
> 
> --
> Jens Axboe
> 
> 

