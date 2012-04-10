Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37040 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2DJMIM (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Apr 2012 08:08:12 -0400
Received: by lbbgg6 with SMTP id gg6so2656475lbb.19
        for <fio@vger.kernel.org>; Tue, 10 Apr 2012 05:08:10 -0700 (PDT)
Message-ID: <4F8422AA.9020005@gmail.com>
Date: Tue, 10 Apr 2012 14:08:10 +0200
From: Hoppetauet <hoppetauet@gmail.com>
MIME-Version: 1.0
Subject: Completion and submission latency
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi

I was wondering about the completion latencies. I have been doing some 
virtual machine testing, and would like some help about what the values 
mean.

3;2.0.6;seqwrite;0;0;0;0;0;0;0;0;0.000000;0.000000;0;0;0.000000;0.000000;1.00%=0;5.00%=0;10.00%=0;20.00%=0;30.00%=0;40.00%=0;50.00%=0;60.00%=0;70.00%=0;80.00%=0;90.00%=0;95.00%=0;99.00%=0;99.50%=0;99.90%=0;99.95%=0;99.99%=0;0%=0;0%=0;0%=0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;4194304;17426;4254;246466;0;0;0.000000;0.000000;3;5439652;228.431381;20540.522574;1.00%=4;5.00%=4;10.00%=5;20.00%=5;30.00%=5;40.00%=6;50.00%=6;60.00%=6;70.00%=6;80.00%=7;90.00%=9;95.00%=15;99.00%=25;99.50%=59;99.90%=548;99.95%=3664;99.99%=325632;0%=0;0%=0;0%=0;3;5439652;228.905854;20540.525416;0;162531;100.000000%;30172.429268;37422.864723;2.337414%;3.129483%;6751;1;20;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.38%;91.44%;6.62%;0.94%;0.27%;0.05%;0.20%;0.02%;0.01%;0.03%;0.01%;0.01%;0.01%;0.01%;0.01%;0.02%;0.01%;0.01%;0.01%;0.01%;0.01%;vda;77;10364;0;12806;4900;19896664;19973372;99.30%

This is one of my test runs. The completion latency stats are as follows:
min: 3
max: 5439652
avg: 228.431381
std: 20540.522574

Does this mean that the maximum amount of time it takes to write 4KB is 
5.4 seconds? Are the values in microseconds or milliseconds (it's 
microseconds right)?
Thanks

