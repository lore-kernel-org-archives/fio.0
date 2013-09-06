Return-Path: <fio-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49067 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3IFNDe (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 6 Sep 2013 09:03:34 -0400
Received: from twin.jikos.cz (dave@localhost [127.0.0.1])
	by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id r86CcC5k010476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <fio@vger.kernel.org>; Fri, 6 Sep 2013 14:38:13 +0200
Received: (from dave@localhost)
	by twin.jikos.cz (8.13.6/8.13.6/Submit) id r86CcCvi010475
	for fio@vger.kernel.org; Fri, 6 Sep 2013 14:38:12 +0200
Date: Fri, 6 Sep 2013 14:38:12 +0200
From: David Sterba <dave@jikos.cz>
Subject: fio --showcmd fails if directory= does not exist
Message-ID: <20130906123812.GB9122@twin.jikos.cz>
Reply-To: dave@jikos.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm using "fio --showcmd file.job" to convert a script to plain
commandline arguments and this fails if the directory specified in job
file does not exist. While this has to be an error if the job is being
executed, it should not be in context of --showcmd.

To reproduce:
$ cat job.fio
[global]
directory=/x

$ fio --showcmd job.fio
fio: /x is not a directory
fio: failed parsing directory=/x
fio: job global dropped

Expected output:
fio --directory=/x

david
