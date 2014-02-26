Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:60317 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaBZX4e convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 26 Feb 2014 18:56:34 -0500
Received: from G9W0364.americas.hpqcorp.net (g9w0364.houston.hp.com [16.216.193.45])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t3427.houston.hp.com (Postfix) with ESMTPS id 669F026B
	for <fio@vger.kernel.org>; Wed, 26 Feb 2014 23:56:33 +0000 (UTC)
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: cpus_allowed per thread behavior
Date: Wed, 26 Feb 2014 23:54:54 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548AB930@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

fio seems to assign the same cpus_allowed/cpumask value to all threads.  I think this allows the OS to move the threads around those CPUs.

In comparison, iometer assigns its worker threads to specific CPUs within the cpumask in round-robin manner.  Would that be worth adding to fio, perhaps with an option like cpus_allowed_policy=roundrobin?


---
Rob Elliott    HP Server Storage




