Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-db3on0114.outbound.protection.outlook.com ([157.55.234.114]:21982
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759827AbaJ3Oev convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 30 Oct 2014 10:34:51 -0400
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= 
	<sbouchex@infovista.com>
Subject: Solaris issue with packed stat structures
Date: Thu, 30 Oct 2014 14:34:48 +0000
Message-ID: <14c6d46030d24183a714b5cf90ca81cc@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Language: fr-FR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I'm the latest source on solaris SPARC and I have BUS errors when generating stats :

Stack looks like this :

0002bac4 sum_stat (17973e, fbc05b38, 1, 0, 0, 22) + 38
 0002cf24 sum_thread_stats (179526, fbc05920, 1, 0, fbd7de7c, 4) + a8
 0003113c __show_run_stats (fe40ad88, 400, 0, 0, 0, 0) + 1124
 000b0b10 fio_backend (0, ffbffcf4, 0, 0, 0, 15c174) + 200
 000e6a40 main     (2, ffbffcf4, ffbffd00, 166130, 0, fefe0180) + c4
 00017844 _start   (0, 0, 0, 0, 0, 0) + 5c

It works fine on intel processors because the hardware is handling the misalignment but on Sparc, it is not handled, so a BUS error is generated

To fix this issue, I have added some padding here :

[...]
uint16_t continue_on_error;
uint16_t continue_on_error_pad;				// <<<<<==== Pading here
uint64_t total_err_count;
uint32_t first_error;
[...]

Thanks
Seb
