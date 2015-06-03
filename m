Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout1b.intuit.com ([206.108.40.7]:63043 "EHLO
	qdcapmail1.data.ie.intuit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753315AbbFCVcI convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Wed, 3 Jun 2015 17:32:08 -0400
From: "Hinson, Roger" <Roger_Hinson@intuit.com>
Subject: RE: Parameter Issue with 'ratemin'...
Date: Wed, 3 Jun 2015 21:22:28 +0000
Message-ID: <CY1PR02MB1303CE323DB544A10F37A24381B40@CY1PR02MB1303.namprd02.prod.outlook.com>
References: <loom.20150603T211024-259@post.gmane.org>
In-Reply-To: <loom.20150603T211024-259@post.gmane.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: FIO-User-KKV <viali.lee@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>



-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of FIO-User-KKV
Sent: Wednesday, June 03, 2015 12:21 PM
To: fio@vger.kernel.org
Subject: Parameter Issue with 'ratemin'...

Hi, I am using Fio 2.2.8.
I have an issue when setting the parameter 'ratemin'.
It only accepts '0'!
no matter what non-zero values I set, 

e.g., 
sudo fio -name "SOURCE"  -numjobs 1  -bs 1M   -rw write -direct 1 -runtime 
50 -filename=/dev/vdb  -prio 0 -ratemin=1K

I will end up quickly with "fio: minimum rate exceeds rate"!
Could anyone know what's wrong there?

Thanks!

--
Hey,

The value of ratemin needs to be an int.  If you want 1000, you need to enter as 1000, not 1K.

Roger


