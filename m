Return-Path: <cheerios123@outlook.com>
Message-ID: <BLU402-EAS37786FC6E4480886241B03CE0BA0@phx.gbl>
Return-Path: cheerios123@outlook.com
From: Jon Tango <cheerios123@outlook.com>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl> <5429B424.7080903@kernel.dk> <BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl> <5429C839.7090408@kernel.dk> <BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl> <5429CD3F.4000307@kernel.dk>
In-Reply-To: <5429CD3F.4000307@kernel.dk>
Subject: RE: Limit LBA Range
Date: Mon, 29 Sep 2014 16:37:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
To: 'Jens Axboe' <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


On 2014-09-29 15:10, Jon Tango wrote:
> I include both of those commands, in addition to size=745g, and it 
> seems to be conducting the workload over the entire LBA range. Is this 
> the correct combination of the three parameters? Here is the test script:

When you explicitly set size=745G, the range is 0..745G as previously
specified.

--
Jens Axboe

--
So it would be both time_based and limited to 745G as well? The workload
will continue to run even if over 745GB of data is written, but only to the
0..745GB range?

size=745G
time_based
runtime=4h

