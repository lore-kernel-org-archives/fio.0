Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2-int.auckland.ac.nz ([130.216.12.41]:57085 "EHLO
	mx2-int.auckland.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0D0A3t (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 26 Apr 2010 20:29:49 -0400
Message-ID: <4BD62D8A.5050109@auckland.ac.nz>
Date: Tue, 27 Apr 2010 12:19:22 +1200
From: Michael O'Sullivan <michael.osullivan@auckland.ac.nz>
MIME-Version: 1.0
Subject: Using offsets in fio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: DongJin Lee <dongjin.lee@auckland.ac.nz>

Hi everyone,

We are using fio to emulate the SPC-1 benchmark (we hope to get this 
included as a --profile in fio in the not too distant future). However, 
we have noticed that when running our benchmark the disk we are testing 
does not seem to be overly busy seeking to different locations on the 
disk. When we run tests using Iometer we can hear the disk seeking to 
different sections of the disk pretty much the whole time. We are using 
io_u->offset to define the position in the file we wish to read/write 
at, but it is not clear to us whether this is having the desired effect. 
It doesn't seem so at this point... We have been using the sync and 
libaio engines.

Can someone please give us some advice to help us troubleshoot this 
problem? Or point us to a tool that will let us see where fio is 
reading/writing on the disk? Any help is greatly appreciated.

Kind regards, Mike
