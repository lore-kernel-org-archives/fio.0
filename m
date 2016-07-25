Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46235 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbcGYRA3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 25 Jul 2016 13:00:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bRjEw-0000zz-Vg
	for fio@vger.kernel.org; Mon, 25 Jul 2016 19:00:27 +0200
Received: from 32.97.110.52 ([32.97.110.52])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Mon, 25 Jul 2016 19:00:26 +0200
Received: from ionictea by 32.97.110.52 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Mon, 25 Jul 2016 19:00:26 +0200
From: Saeed <ionictea@gmail.com>
Subject: fio jobs time_based & runtime scope
Date: Mon, 25 Jul 2016 12:00:13 -0500
Message-ID: <nn5git$q4l$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

If a job file contains x number of job declarations ([jobxx]) how does 
the 'time_based" and 'runtime' scoped?

Is it per job declaration or inclusive of all the job declarations in 
the file?  I'm trying to set a limit in run time to have the jobs run 
until a certain amount of time has been reached and the jobs still run 
over the 'runtime' defined limit


