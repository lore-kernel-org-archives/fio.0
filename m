Return-Path: <fio-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:62804 "EHLO
	alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaATLAt convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 20 Jan 2014 06:00:49 -0500
Received: from xhc-aln-x10.cisco.com (xhc-aln-x10.cisco.com [173.36.12.84])
	by rcdn-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id s0KApMFG006692
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Mon, 20 Jan 2014 10:51:22 GMT
From: "Roopeshakumar Narayansa Shalgar (rshalgar)" <rshalgar@cisco.com>
Subject: Fio crashes in setup_file
Date: Mon, 20 Jan 2014 10:51:21 +0000
Message-ID: <F9567754259D974D88F5F5337C9D21962022C70F@xmb-aln-x11.cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

The moment I define a new variable under thread_options I start seeing a crash in 'setup_files' files 
Function.  Backtrace points to the following lline:

if (td->io_ops->setup).  Gdb shows the value of null for io_ops. 


So essentially what's happenings is io_ops is not getting set correctly when I add a new
variable under 'thread_options' structures.


This can be easily reproduced by simply adding a variable under thread_options structiure. 
No other changes are required. Can someone help? 

/rK
