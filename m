Return-Path: <fio-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:49704 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1ABENF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 1 Jan 2011 23:13:05 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NW4WZX22SWNG6FAQ@mx.isti.cnr.it> for
 fio@vger.kernel.org; Sun, 02 Jan 2011 05:12:00 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NW4WZWCTV4NG6FAP@mx.isti.cnr.it> for
 fio@vger.kernel.org; Sun, 02 Jan 2011 05:11:58 +0100 (MET)
Received: from [10.0.0.61]
 (dynamic-adsl-78-12-75-177.clienti.tiscali.it [78.12.75.177])
 by mx.isti.cnr.it (PMDF V6.5-x5 #31826)
 with ESMTPSA id <01NW4WZUVRI0NV288K@mx.isti.cnr.it> for fio@vger.kernel.org;
 Sun, 02 Jan 2011 05:11:56 +0100 (MET)
Date: Sun, 02 Jan 2011 05:12:09 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Suggestion on size= and test length
Message-id: <4D1FFB19.7020202@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Dear fio developers,

Thanks for the very good application, but may I suggest that the size= 
option controls only the size of the files used for the test (in 
particular random r/w tests), while there should be another option 
totaltransfer= which controls how long is the test? And/or a walltime= 
option to make the test length time based... even better!

Currently we either are hit by short seeks (size= small) or have to wait 
for impossibly long tests uselessly (size= large).

Thank you
