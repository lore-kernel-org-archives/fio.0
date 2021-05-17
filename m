Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr80100.outbound.protection.outlook.com ([40.107.8.100]:21279
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232924AbhEQIue (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 May 2021 04:50:34 -0400
From: Erwan Velu <e.velu@criteo.com>
Subject: Adding exec engine
Message-ID: <a6eb5db2-8a66-bf1b-fe46-c4c854b46a58@criteo.com>
Date: Mon, 17 May 2021 10:49:15 +0200
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hey fellows,

I sent a github pull request (https://github.com/axboe/fio/pull/1228) to 
add a new engine to manage concurrent execution of 3rd party tools.

When performing benchmarks with fio, some have the need of executing
tasks in parallel of the job execution. A typical usecase would be
observing performance/power metrics.

Several implementations were possible :

  * Adding an exec_run in addition of the existing exec_{pre|post}run
  * Implementing performance/power metrics in fio
  * Adding an exec engine

1°) Adding an exec_run
This was my first intention but quickly noticed that exec_{pre-post}run
are executed for each 'numjob'. In the case of performance/power
monitoring, this doesn't make sense to spawn an instance for each
threads.

2°) Implementing performance/power metrics
This is possible but would required lot of work to maintain this part of
fio while 3rd party tools already take care of that perfectly.

3°) Adding an engine
Adding a engine let users defining when and how many instance of the
program they want.
In the provided example, a single monitoring job is spawn at the same
time of the worker thread which could be composed of several worker
threads.
A stonewall barrier is used to define which jobs must run together
(monitoring / benchmark).

The engine has two parameters :

  * program: name of the program to run
  * arguments: arguments to pass to the program

Arguments can have special variables to be expanded before the execution:

  * %r will be replaced by the job duration in seconds
  * %n will be replaced by the job name

During the program execution, the std{out|err} are redirected to files

  * stdout: <job_name>.stdout
  * stderr: <job_name>.stderr

If the executed program has a nice stdout output, after the fio
execution, the stdout file can be parsed by other tools like CI jobs or 
graphing tools.

A sample job is provided here to show how this can be used.
It runs twice the cpu engine with two different cpu mode (noop vs qsort).
For each benchmark, the output of turbostat is saved to later analysis.
After the fio run, it is possible to compare the impact of the two modes
on the CPU frequency and power consumption.

This can be easily extended to any other usage that needs to analysis
the behavior of the host during some jobs.

About the implementation, the exec engine forks :

  * the child doing an execvp() of the program.
  * the parent, fio, will monitoring the time passed into the job

Once the time is over, the program is SIGTERM followed by a SIGKILL to
ensure it will not run /after/ the job completed.
This mechanism is required as :

  * not all programs can be controlled properly
  * that's a last resort protection if the program gets crazy

If the program can be limited in its duration, using the %r variable in
the arguments can be used to request the program to stop /before/ the
job finished like :
program=/usr/bin/mytool.sh
arguments=--duration %r

Erwan,

