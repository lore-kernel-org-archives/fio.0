Return-Path: <fio-owner@vger.kernel.org>
Received: from [213.199.154.80] ([213.199.154.80]:49995 "EHLO
	emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751766AbaDCLRT convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 3 Apr 2014 07:17:19 -0400
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= 
	<sbouchex@infovista.com>
Subject: fio crash when using an env variable that is not set
Date: Thu, 3 Apr 2014 11:16:56 +0000
Message-ID: <d1e49b99b2164d5d825c50e11bb349a9@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

A crash on solaris & windows (at least) when using fio-2.1.6.1 :

A simple profile that use a env variable : directory=${DIRECTORY}

I'm starting fio without defining DIRECTORY and I'm getting a crash:

The stack on solaris is :

core 'core' of 4574:    ./fio ../fio_env.win
 0000000100035348 set_name_idx (ffffffff7fffe970, 100231950, 0, 16c4e8, 0, 1002319b0) + cc
 0000000100021a70 add_file (ffffffff7b400000, ffffffff7fffee60, 0, 0, 100071c30, ffffffff7fffe970) + 38
 000000010000daf4 add_job.part.4 (7, 100236050, 0, ffffffff7ffff268, 1, 0) + 11f0
 000000010000f444 parse_jobs_ini (0, 0, 0, 1, 100236050, 1002276c0) + 77c
 0000000100010db0 parse_options (5118, ffffffff7ffff968, 1, 0, 0, 10021eef0) + 304
 000000010006ff68 main (2, ffffffff7ffff968, ffffffff7ffff980, 100228338, 100000000, 2800) + 20
 000000010000952c _start (0, 0, 0, 0, 0, 0) + 7c

Seb

