Return-Path: <fio-owner@vger.kernel.org>
Received: from serv4.rootleveltech.com ([198.176.28.4]:53587 "EHLO
	serv4.rootleveltech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbbBZFIJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 Feb 2015 00:08:09 -0500
Message-ID: <54EE9B5D.3040208@voicenet.com>
Date: Wed, 25 Feb 2015 23:04:45 -0500
From: thoms <thoms@voicenet.com>
Reply-To: thoms@voicenet.com
MIME-Version: 1.0
Subject: Stonewalled ?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi folks,

I'm running fio-2.2.5 on a Linux x86_64 platform.  This is the first
time I've had to create a job file with an extremely large number of job
sections within the same file (hundreds of jobs).  I need each job to
run sequentially and have included "stonewall" within each section. 
When I execute the job file, I get this error:

  error: maximum number of jobs (2048) reached.

When I reduce the number of job sections in the file to under 200, the
job runs sequentially as expected. 

My understanding of "stonewall" is that it should serialize the running
of each job within a file (or files).  The implication is that fio
shouldn't be evaluating a subsequent job section until after the current
job has fully completed.  But in this case, fio appears to be looking
ahead and ignoring the "stonewall" directive until it exhausts
resources. This behavior also occurs within the current git commit.

Is this a feature or a bug, and is there another way to tell fio to
execute each job sequentially (top to bottom) as it encounters them in
the file?

Thanks!
