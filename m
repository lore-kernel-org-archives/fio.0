Return-Path: <fio-owner@vger.kernel.org>
Received: from mxe1.gs.com ([204.4.187.100]:12089 "EHLO mxecd01.gs.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752412AbYLASuu convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 1 Dec 2008 13:50:50 -0500
From: "Baur, Eric" <Eric.Baur@gs.com>
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: terse output for IO latencies
Date: Mon, 1 Dec 2008 13:45:46 -0500
Message-ID: <4DCBAA39733E8048992FB7737126041910FFD998@gsmbnbp23es.firmwide.corp.gs.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

In the HOWTO for fio, the terse output for IO latencies is described as:

"IO latencies: <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000, >=2000"

Output from certain test runs have been observed to have more than 11
values for IO latencies, For example:

0.01%, 0.00%, 0.01%, 0.01%, 0.06%, 0.73%, 35.42%, 7.19%, 3.03%, 0.52%,
2.79%, 13.67%, 32.84%, 2.86%, 0.84%, 0.02%, 0.01%, 0.00%, 0.00%, 0.00%,
0.00%, 0.00%

What are the proper labels for this output?

Thanks,
Eric
