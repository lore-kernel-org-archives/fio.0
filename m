Return-Path: <fio-owner@vger.kernel.org>
Received: from edge10.ethz.ch ([82.130.75.186]:58673 "EHLO edge10.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab1COIdu convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 15 Mar 2011 04:33:50 -0400
From: "N. Harake" <hussein@cscs.ch>
Subject: memory caching 
Date: Tue, 15 Mar 2011 08:27:39 +0000
Message-ID: <C9A4E18A.10660%hussein@cscs.ch>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <84AAB5CBA1D5B94FAB3A93B01177A8D8@intern.ethz.ch>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>


I would like to disable completely the caching in memory, trying to measure real throughput read/write and iops on filesystem (not raw access).
Other than direct=1 is there any flag I could use to obtain such complete bypass caching?

Regards
H. N. Harake
