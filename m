Return-Path: <fio-owner@vger.kernel.org>
Received: from sjc00mx1.hitachigst.com ([199.255.44.36]:15989 "EHLO
	sjc00mx1.hgst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbcAVU2S convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 22 Jan 2016 15:28:18 -0500
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: RE: Feature request: log max msec
Date: Fri, 22 Jan 2016 20:28:14 +0000
Message-ID: <BN3PR0401MB1457821A65AD3471B589FCD7F7C40@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457729D4CAE5B9911ABB967F7CA0@BN3PR0401MB1457.namprd04.prod.outlook.com>
In-Reply-To: <BN3PR0401MB1457729D4CAE5B9911ABB967F7CA0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Any thoughts on this topic?  Looking for a way to log max latency samples every 10s or 30s for a duration of hours or days, with nonstop IO.  Buffering every IO latency to DRAM would require TB's of DRAM, but could be easily post processed for max latency samples after the IO stops.  --log_avg_msec seems to buffer just averages based on a specified time period (not max).  Thanks.

Regards,
Jeff


-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Jeff Furlong
Sent: Monday, January 11, 2016 5:09 PM
To: fio@vger.kernel.org
Subject: Feature request: log max msec

Hi All,
It would be useful to have a feature such as --log_max_msec that would take snapshots of IO's run for the time specified by --log_max_msec and determine the maximum IOPs/latency/bw per snapshot period.  It would operate very much like --log_avg_msec, but instead of logging averages per snapshot period, it would log (local) maximums.  Max IOPs/bw may not have too much value, but max latency would be insightful.  Current options seem only to log all latencies (--log_avg_msec=0) or get only the single maximum after the job completes.  Thoughts?  Thanks.

Regards,
Jeff

HGST E-mail Confidentiality Notice & Disclaimer:
This e-mail and any files transmitted with it may contain confidential or legally privileged information of HGST and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited.  If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

