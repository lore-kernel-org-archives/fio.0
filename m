Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42293 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2G0X6p (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 27 Jul 2012 19:58:45 -0400
Received: by obbuo13 with SMTP id uo13so5013169obb.19
        for <fio@vger.kernel.org>; Fri, 27 Jul 2012 16:58:44 -0700 (PDT)
MIME-Version: 1.0
From: Kyle Hailey <kyle.hailey@delphix.com>
Date: Fri, 27 Jul 2012 16:58:24 -0700
Message-ID: <CACiQ3FAhrVoXJDuBGLx8okyFLNMd1_J2mRkxz4kKJdTty5OoNA@mail.gmail.com>
Subject: analyzing, visualizing, understanding and rating fio data
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I've been testing out fio a bit and found it more flexible than the
other popular I/O benchmark tools such as Iozone and Bonnie++ and fio
has a more active user community.

In order to easily run fio tests, I've written a wrapper script to go
through a series of tests.
In order to understand the output, I've written a wrapper script to
extract and format the results of multiple tests.
In order to try and understand the data I've written some graph routines in R.

The output of the graph routines is visible here:

     sites.google.com/site/oraclemonitor/i-o-graphics#TOC-Percentile-Latency

The scripts to run the tests, extract the data and graph the data in R
are available here:

      github.com/khailey/fio_scripts/blob/master/README.md

My main question is how does one extract key metrics from fio  runs
and what steps does one take to understand and or rate the I/O
subsystems based on the data?

My area of interest is database I/O performance.  Databases have
certain typical I/O access profiles.
Most notably databases primarily do random I/O of a set size,
typically 8K (though this can vary from 2K to 32K).

Looking at 1000s of database reports I typically see random I/O around
6ms-8ms on solid
gear occasionally faster if some has some serious caching on the SAN
and occasionally
slower when the I/O subsystem is overtaxed, which fits into some
numbers I just grab from a
Google search:

speed  rot_lat  seek     total
10K    3ms      4.3ms    =  7.3
15K    2ms      3.8ms    =  5.8


For rating I/O it seems easy to say something,  for random I/O, like

< 5ms awesome
< 7ms good
< 9ms pretty good
> 9ms starting to have contention or slower gear


First I'm sure these numbers are debatable, but more importantly they
don't take into account throughput.
The latency of a single users should be the base latency and then
there should be a second value which the throughput that the I/O
subsystem can sustain with some close factor of that base latency.

The above also doesn't take into account  wide distributions of
latency and outliers. For outliers, how important is it that the
99.99% is far from average?  How concerning is it that the max is
multi-second when the average is good?


- Kyle
