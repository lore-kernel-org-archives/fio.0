Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55321 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbbLIRUF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Dec 2015 12:20:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1a6iPL-0004Ew-H7
	for fio@vger.kernel.org; Wed, 09 Dec 2015 18:20:03 +0100
Received: from pc1mwgproxy08-dmz.us.dell.com ([143.166.255.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 09 Dec 2015 18:20:03 +0100
Received: from Kurt_Dorsey by pc1mwgproxy08-dmz.us.dell.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 09 Dec 2015 18:20:03 +0100
From: Kurt Dorsey <Kurt_Dorsey@Dell.com>
Subject: Feature Request, Job Info inserted into json output
Date: Wed, 9 Dec 2015 16:10:58 +0000 (UTC)
Message-ID: <loom.20151209T170827-533@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi All,

I have a feature request.   One of the things that is missing (in my 
opinion) from the json output is the actual fio job configuration.

In the current state it outputs a json file with all the output from the 
jobs run.  One addition that would make it very helpful for parsing and 
comparing data (especially historical data  or data run by another 
engineer) is to have the actual job file as a key inside the json 
output.  This could be something as simple as just putting the parsed 
command line argument in

fio --ioengine=libaio --buffered=0 --norandommap --log_avg_msec=10000 --
direct=1 --ba=4k --ramp_time=0 --runtime=1800 --time_based --
filename=/dev/sdg --name=8K_RR_QD1 --name=8K_RR_QD1 --bs=8k --
rw=randread --iodepth=1 --write_iops_log=./8K_RR_qd1_

Or even better would be a dictionary inside the json with every 
configuration parameter verbosely printed (like the below "jobinfo")



{
  "fio version" : "fio-2.1.10",
  "jobs" : [
    {
      "jobname" : "8K_Random_Read",
      "jobinfo" :{
        "ioengine" : "libaio"
        "buffered" : 0
        "norandommap" : 1
        "log_avg_msec" : 10000
        "direct" : 1
        "ba" : 4k
        "ramp_time" : 0
        "runtime" :1800
        "time_based" : 1
        "filename" : "/dev/sdc"
        "name" : "8K_Random_Read"
        "bs" : "8K"
        "rw" : "randread"
        "iodepth" : 1
      }
      "groupid" : 0,
      "error" : 0,
      "read" : {


I understand it would add size to the output but I think it would really 
help.

Thoughts?
-Kurt

