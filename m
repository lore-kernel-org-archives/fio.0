Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:49535 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab2EJCDD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 May 2012 22:03:03 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id h9ai0gbh926pY7f1 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <fio@vger.kernel.org>; Wed, 09 May 2012 19:48:34 -0600 (MDT)
Message-ID: <4FAB1E71.3030304@fusionio.com>
Date: Wed, 9 May 2012 19:48:33 -0600
From: Rusty Weber <RWeber@fusionio.com>
MIME-Version: 1.0
Subject: commdand line output
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Command line output is spuradic while running because fio replaces the 
last line while updating the status of the process instead of replacing 
the update string.
EXAMPLE:
consider the update string as following

Jobs: 1 (f=1): [m] [61.9% done] [112.8M/123.6M /s] [123 /125  iops] [eta 
00m:08s]

however, if the command prompt's line buffer size is smaller than the 
length of the update string, the update string gets separated into 2 lines:

Jobs: 1 (f=1): [m] [61.9% done] [112.8M/123.6M /s] [123 /125  iops]
  [eta 00m:08s]

which means that on the next update string you write, after removing the 
current line, you will end up with

Jobs: 1 (f=1): [m] [61.9% done] [112.8M/123.6M /s] [123 /125  iops]
Jobs: 1 (f=1): [m] [65.2% done] [112.8M/123.6M /s] [129 /150  iops]
  [eta 00m:08s]

on the console output....  I thought this was a feature and was using it 
to my advantage until I started receiving low throughput values which 
started making my status update strings smaller than the line buffer 
size resulting in a single line of output.  In order to fix, you need to 
remove a status update string with the equivalent length of the last 
string written using \b.
example
status update="I am an update"
to remove you send "\b\b\b\b\b\b\b\b\b\b\b\b\b\b" to stdout

I would also like to make a feature request of a verbose option that 
disables the replacement of output as described above as the output 
information can be extremely useful in certain cases; in my case I would 
like very high resolution output of the instantaneous throughput and not 
a summary at the end.



Environment: windows
version:fio-2.0.7-9g5c3f


-- 
Russell Weber


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.  Email addresses that end with a ?-c? identify the sender as a Fusion-io contractor.
