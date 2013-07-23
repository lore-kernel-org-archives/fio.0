Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:47380 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932543Ab3GWQwx convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 23 Jul 2013 12:52:53 -0400
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Helping to model this workload
Date: Tue, 23 Jul 2013 16:52:43 +0000
Message-ID: <CE142D08.127FB%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <CE142CC7.127F5%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F16B2C12ECE38C4C946588331213C5FF@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All

This is neto from Brazil

How are you?

I need to model the following workload:

Sequential Read % 35.0
Sequential Write % 5.0
Random Read % 50.0
Random Write % 10.0
Random Read Working Set(GB) 1000.0
Random Write Working Set(GB) 1000.0
Sequential Read Size(KB) 64KB
Sequential Write Size(KB) 64KB
Random Read Size(KB) 8KB
Random Write Size(KB) 8KB

For the random workload =EF=BF=BD I thought to use 16 jobs with 2 outstandi=
ng IOs.
For sequential workload, I cannot use more than one job (because this will
become random) and I need to use 64 outstanding
 Ios.

My biggest doubt is: how to distribute the percentage in the job file?

Does anyone have any example to share?

Thank you very much

All the best

neto

