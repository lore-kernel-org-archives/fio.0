Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:37679 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3FYRqa (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 25 Jun 2013 13:46:30 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 062CD12108
	for <fio@vger.kernel.org>; Tue, 25 Jun 2013 19:13:14 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 03530780C1E
	for <fio@vger.kernel.org>; Tue, 25 Jun 2013 19:13:14 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ooU655xEIKZd for <fio@vger.kernel.org>;
	Tue, 25 Jun 2013 19:13:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 9B2EF63DE40E
	for <fio@vger.kernel.org>; Tue, 25 Jun 2013 19:13:13 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7avaERsEyjYK for <fio@vger.kernel.org>;
	Tue, 25 Jun 2013 19:13:13 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id DCBE663DE40D
	for <fio@vger.kernel.org>; Tue, 25 Jun 2013 19:13:12 +0200 (CEST)
Message-ID: <51C9CFA8.6080703@enovance.com>
Date: Tue, 25 Jun 2013 19:13:12 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Pull Request for Adding 2 new tools around fio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hey Jens,

I'm been using fio for years and that's a wonderful tool. Since I'm 
working at eNovance, I'm facing situations where I shall compare servers 
and disks in a clusterized environnement.

In my last case, I had 6 servers with 33 disks each leading to a serious 
problem. How can I test and visualize performances in various io pattern :
- read, write, randread, randwrite
- 4k, 128k, 1m block size
- one disk after the other (to estimate the performance of each disk 
helping tracking the weaks)
- all the disks at the same time (to estimate the ability of the host to 
manage all disks at the same time)

To help setting up this benchmark, I've been doing two tools :
- genfio to generate the fio script files
Details of its behavior & options can be found in the commit itself 
(also available with the -help option)
A single command like 'genfio -d sdb,sdc,sdd,sde -a -b 4k,128k,1m -r 
100' generates a single fio file that will runs 60 tests on 4 disks 
during 100 seconds each. That does avoid human mistake and ease 
reproductability

https://github.com/enovance/fio/commit/ca0ede58c1ca10469d9937110c3faa30ce88ca1f

- fio2gnuplot turns the output log from fio into gnuplot traces
It does help tracing many log files in a friendly way by using 3D graphs 
(to avoid 2D overlapping) or generates several histograms to compare 
min/max/avg/stddev of some selected outputfile. If outputfiles
are well named (like if you use genfio) you can use regexp to select the 
files you want to graph.
You can so select logs by the io pattern, the name of disk, etc...
More details in the commit or in the --help option
https://github.com/enovance/fio/commit/1fa4c6436b31b71ab2bb373a5033a62bca47bce0

I've been uploading some sample output here : 
http://www.flickr.com/photos/ennael/sets/72157634249027122/

In a fraction of seconds, you are able to visualize the global 
performances with the 3D graph and compared values betweens runs by 
using the histograms. On a real 6 servers, 197 disks (33 each), it 
helped at detecting the weak devices very quickly.

I hope this work will have some interest for the fio project or maybe 
some other users.

This two tools are available on my 'tools' branch of my github 
repository. It's on top the current master so very easy to merge. Both 
tools are splitted in two commits.

https://github.com/enovance/fio/tree/tools

Sincerly,
Erwan Velu
