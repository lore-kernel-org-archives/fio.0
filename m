Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41882 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2DSHbv (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Apr 2012 03:31:51 -0400
Received: by lbom4 with SMTP id m4so2872325lbo.19
        for <fio@vger.kernel.org>; Thu, 19 Apr 2012 00:31:50 -0700 (PDT)
Message-ID: <4F8FBF66.9050109@gmail.com>
Date: Thu, 19 Apr 2012 09:31:50 +0200
From: Hoppetauet <hoppetauet@gmail.com>
MIME-Version: 1.0
Subject: High standard deviation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello

Can someone give some insight as to why the standard deviation for 
completion latencies is so high?

I have a completion latency avg of 0.21ms, while the st dev is 12.33ms. 
Is it because of some really high numbers here and there?

Also, can someone tell me where the total latency is located in this 
--minimal output

work;0;0;8388608;55741;154103;0;0;0.000000;0.000000;1;1323005;69.848293;1088.205315;0;60512;104.688135%;56986.986348;4117.299600;0;0;0;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;1.109655%;3.491194%;32878;0;33;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;53.89%;44.49%;0.05%;0.01%;0.01%;0.01%;0.00%;0.01%;0.00%;0.01%;0.01%;0.84%;0.72%;0.01%;0.01%;0.01%;0.00%;0.01%;0.00%;0.00%;0.01%;0.00%

Thanks

