Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34620 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162180AbbKTR3R (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Nov 2015 12:29:17 -0500
Received: by qkfo3 with SMTP id o3so38878861qkf.1
        for <fio@vger.kernel.org>; Fri, 20 Nov 2015 09:29:16 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 20 Nov 2015 09:29:16 -0800
Message-ID: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
Subject: Bug with --buffer_compress_percentage
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I noticed that sometimes using --buffer_compress_percentage would not
result in the desired compression.  After running some tests I found
that only some block sizes are affected.

512b, 4K, 8K, 16K, and 32K seem to work as expected.

64K, 128K, 256K, 512K, and 1024K exhibited the bug.  I have not tested
beyond 1024K.

Here is the test script I used only changing block size for each test.

for i in {0..100}; do
  fio --name=test --rw=write --bs=128k --ioengine=libaio --direct=1
--iodepth=32 --size=512m --refill_buffers
--buffer_compress_percentage=$i --filename=testfile.$i --eta=never
--output=/dev/null
done

for i in {0..100}; do
  gzip -v testfile.$i &>> gzip.txt
done

rm *.gz

Below are compression results for 4K and then 128K.  For 128K, you can
see compression stops matching at around 50%.

bs=4k

testfile.0:      0.3% -- replaced with testfile.0.gz
testfile.1:      1.2% -- replaced with testfile.1.gz
testfile.2:      2.2% -- replaced with testfile.2.gz
testfile.3:      3.2% -- replaced with testfile.3.gz
testfile.4:      4.1% -- replaced with testfile.4.gz
testfile.5:      5.1% -- replaced with testfile.5.gz
testfile.6:      6.1% -- replaced with testfile.6.gz
testfile.7:      7.1% -- replaced with testfile.7.gz
testfile.8:      8.1% -- replaced with testfile.8.gz
testfile.9:      9.1% -- replaced with testfile.9.gz
testfile.10:     10.1% -- replaced with testfile.10.gz
testfile.11:     11.1% -- replaced with testfile.11.gz
testfile.12:     12.1% -- replaced with testfile.12.gz
testfile.13:     13.1% -- replaced with testfile.13.gz
testfile.14:     14.1% -- replaced with testfile.14.gz
testfile.15:     15.1% -- replaced with testfile.15.gz
testfile.16:     16.0% -- replaced with testfile.16.gz
testfile.17:     17.0% -- replaced with testfile.17.gz
testfile.18:     18.0% -- replaced with testfile.18.gz
testfile.19:     19.0% -- replaced with testfile.19.gz
testfile.20:     20.0% -- replaced with testfile.20.gz
testfile.21:     21.0% -- replaced with testfile.21.gz
testfile.22:     22.0% -- replaced with testfile.22.gz
testfile.23:     23.0% -- replaced with testfile.23.gz
testfile.24:     24.0% -- replaced with testfile.24.gz
testfile.25:     25.0% -- replaced with testfile.25.gz
testfile.26:     25.9% -- replaced with testfile.26.gz
testfile.27:     26.9% -- replaced with testfile.27.gz
testfile.28:     27.9% -- replaced with testfile.28.gz
testfile.29:     28.9% -- replaced with testfile.29.gz
testfile.30:     29.9% -- replaced with testfile.30.gz
testfile.31:     30.9% -- replaced with testfile.31.gz
testfile.32:     31.9% -- replaced with testfile.32.gz
testfile.33:     32.9% -- replaced with testfile.33.gz
testfile.34:     33.9% -- replaced with testfile.34.gz
testfile.35:     34.9% -- replaced with testfile.35.gz
testfile.36:     35.9% -- replaced with testfile.36.gz
testfile.37:     36.9% -- replaced with testfile.37.gz
testfile.38:     37.9% -- replaced with testfile.38.gz
testfile.39:     38.9% -- replaced with testfile.39.gz
testfile.40:     39.9% -- replaced with testfile.40.gz
testfile.41:     40.8% -- replaced with testfile.41.gz
testfile.42:     41.8% -- replaced with testfile.42.gz
testfile.43:     42.8% -- replaced with testfile.43.gz
testfile.44:     43.8% -- replaced with testfile.44.gz
testfile.45:     44.8% -- replaced with testfile.45.gz
testfile.46:     45.8% -- replaced with testfile.46.gz
testfile.47:     46.8% -- replaced with testfile.47.gz
testfile.48:     47.8% -- replaced with testfile.48.gz
testfile.49:     48.8% -- replaced with testfile.49.gz
testfile.50:     49.8% -- replaced with testfile.50.gz
testfile.51:     50.3% -- replaced with testfile.51.gz
testfile.52:     51.2% -- replaced with testfile.52.gz
testfile.53:     52.3% -- replaced with testfile.53.gz
testfile.54:     53.2% -- replaced with testfile.54.gz
testfile.55:     54.2% -- replaced with testfile.55.gz
testfile.56:     55.3% -- replaced with testfile.56.gz
testfile.57:     56.1% -- replaced with testfile.57.gz
testfile.58:     57.2% -- replaced with testfile.58.gz
testfile.59:     58.2% -- replaced with testfile.59.gz
testfile.60:     59.2% -- replaced with testfile.60.gz
testfile.61:     60.2% -- replaced with testfile.61.gz
testfile.62:     61.2% -- replaced with testfile.62.gz
testfile.63:     62.2% -- replaced with testfile.63.gz
testfile.64:     63.2% -- replaced with testfile.64.gz
testfile.65:     64.1% -- replaced with testfile.65.gz
testfile.66:     65.2% -- replaced with testfile.66.gz
testfile.67:     66.2% -- replaced with testfile.67.gz
testfile.68:     67.2% -- replaced with testfile.68.gz
testfile.69:     68.2% -- replaced with testfile.69.gz
testfile.70:     69.2% -- replaced with testfile.70.gz
testfile.71:     70.2% -- replaced with testfile.71.gz
testfile.72:     71.2% -- replaced with testfile.72.gz
testfile.73:     72.2% -- replaced with testfile.73.gz
testfile.74:     73.2% -- replaced with testfile.74.gz
testfile.75:     74.3% -- replaced with testfile.75.gz
testfile.76:     75.2% -- replaced with testfile.76.gz
testfile.77:     76.1% -- replaced with testfile.77.gz
testfile.78:     77.2% -- replaced with testfile.78.gz
testfile.79:     78.2% -- replaced with testfile.79.gz
testfile.80:     79.1% -- replaced with testfile.80.gz
testfile.81:     80.1% -- replaced with testfile.81.gz
testfile.82:     81.2% -- replaced with testfile.82.gz
testfile.83:     82.2% -- replaced with testfile.83.gz
testfile.84:     83.1% -- replaced with testfile.84.gz
testfile.85:     84.2% -- replaced with testfile.85.gz
testfile.86:     85.1% -- replaced with testfile.86.gz
testfile.87:     86.1% -- replaced with testfile.87.gz
testfile.88:     87.2% -- replaced with testfile.88.gz
testfile.89:     88.2% -- replaced with testfile.89.gz
testfile.90:     89.2% -- replaced with testfile.90.gz
testfile.91:     90.1% -- replaced with testfile.91.gz
testfile.92:     91.1% -- replaced with testfile.92.gz
testfile.93:     92.0% -- replaced with testfile.93.gz
testfile.94:     93.2% -- replaced with testfile.94.gz
testfile.95:     94.1% -- replaced with testfile.95.gz
testfile.96:     95.0% -- replaced with testfile.96.gz
testfile.97:     96.4% -- replaced with testfile.97.gz
testfile.98:     97.3% -- replaced with testfile.98.gz
testfile.99:     98.5% -- replaced with testfile.99.gz
testfile.100:     99.9% -- replaced with testfile.100.gz

bs=128k

testfile.0:      0.3% -- replaced with testfile.0.gz
testfile.1:      1.3% -- replaced with testfile.1.gz
testfile.2:      2.3% -- replaced with testfile.2.gz
testfile.3:      3.3% -- replaced with testfile.3.gz
testfile.4:      4.2% -- replaced with testfile.4.gz
testfile.5:      5.2% -- replaced with testfile.5.gz
testfile.6:      6.2% -- replaced with testfile.6.gz
testfile.7:      7.2% -- replaced with testfile.7.gz
testfile.8:      8.2% -- replaced with testfile.8.gz
testfile.9:      9.2% -- replaced with testfile.9.gz
testfile.10:     10.2% -- replaced with testfile.10.gz
testfile.11:     11.2% -- replaced with testfile.11.gz
testfile.12:     12.2% -- replaced with testfile.12.gz
testfile.13:     13.2% -- replaced with testfile.13.gz
testfile.14:     14.2% -- replaced with testfile.14.gz
testfile.15:     15.2% -- replaced with testfile.15.gz
testfile.16:     16.1% -- replaced with testfile.16.gz
testfile.17:     17.1% -- replaced with testfile.17.gz
testfile.18:     18.1% -- replaced with testfile.18.gz
testfile.19:     19.1% -- replaced with testfile.19.gz
testfile.20:     20.1% -- replaced with testfile.20.gz
testfile.21:     21.1% -- replaced with testfile.21.gz
testfile.22:     22.1% -- replaced with testfile.22.gz
testfile.23:     23.1% -- replaced with testfile.23.gz
testfile.24:     24.1% -- replaced with testfile.24.gz
testfile.25:     25.1% -- replaced with testfile.25.gz
testfile.26:     26.1% -- replaced with testfile.26.gz
testfile.27:     27.1% -- replaced with testfile.27.gz
testfile.28:     28.1% -- replaced with testfile.28.gz
testfile.29:     29.1% -- replaced with testfile.29.gz
testfile.30:     30.0% -- replaced with testfile.30.gz
testfile.31:     31.0% -- replaced with testfile.31.gz
testfile.32:     32.0% -- replaced with testfile.32.gz
testfile.33:     33.0% -- replaced with testfile.33.gz
testfile.34:     34.0% -- replaced with testfile.34.gz
testfile.35:     35.0% -- replaced with testfile.35.gz
testfile.36:     36.0% -- replaced with testfile.36.gz
testfile.37:     37.0% -- replaced with testfile.37.gz
testfile.38:     38.0% -- replaced with testfile.38.gz
testfile.39:     39.0% -- replaced with testfile.39.gz
testfile.40:     40.0% -- replaced with testfile.40.gz
testfile.41:     41.0% -- replaced with testfile.41.gz
testfile.42:     42.0% -- replaced with testfile.42.gz
testfile.43:     43.0% -- replaced with testfile.43.gz
testfile.44:     44.0% -- replaced with testfile.44.gz
testfile.45:     45.0% -- replaced with testfile.45.gz
testfile.46:     46.0% -- replaced with testfile.46.gz
testfile.47:     47.0% -- replaced with testfile.47.gz
testfile.48:     47.9% -- replaced with testfile.48.gz
testfile.49:     48.9% -- replaced with testfile.49.gz
testfile.50:     49.9% -- replaced with testfile.50.gz
testfile.51:     48.9% -- replaced with testfile.51.gz
testfile.52:     47.9% -- replaced with testfile.52.gz
testfile.53:     47.0% -- replaced with testfile.53.gz
testfile.54:     46.0% -- replaced with testfile.54.gz
testfile.55:     45.0% -- replaced with testfile.55.gz
testfile.56:     44.0% -- replaced with testfile.56.gz
testfile.57:     43.0% -- replaced with testfile.57.gz
testfile.58:     42.0% -- replaced with testfile.58.gz
testfile.59:     41.0% -- replaced with testfile.59.gz
testfile.60:     40.0% -- replaced with testfile.60.gz
testfile.61:     39.0% -- replaced with testfile.61.gz
testfile.62:     38.0% -- replaced with testfile.62.gz
testfile.63:     37.0% -- replaced with testfile.63.gz
testfile.64:     36.0% -- replaced with testfile.64.gz
testfile.65:     35.0% -- replaced with testfile.65.gz
testfile.66:     34.0% -- replaced with testfile.66.gz
testfile.67:     34.0% -- replaced with testfile.67.gz
testfile.68:     36.0% -- replaced with testfile.68.gz
testfile.69:     38.0% -- replaced with testfile.69.gz
testfile.70:     40.0% -- replaced with testfile.70.gz
testfile.71:     42.0% -- replaced with testfile.71.gz
testfile.72:     43.9% -- replaced with testfile.72.gz
testfile.73:     45.9% -- replaced with testfile.73.gz
testfile.74:     47.9% -- replaced with testfile.74.gz
testfile.75:     49.9% -- replaced with testfile.75.gz
testfile.76:     47.9% -- replaced with testfile.76.gz
testfile.77:     45.9% -- replaced with testfile.77.gz
testfile.78:     43.9% -- replaced with testfile.78.gz
testfile.79:     41.9% -- replaced with testfile.79.gz
testfile.80:     40.0% -- replaced with testfile.80.gz
testfile.81:     42.9% -- replaced with testfile.81.gz
testfile.82:     45.9% -- replaced with testfile.82.gz
testfile.83:     48.9% -- replaced with testfile.83.gz
testfile.84:     47.9% -- replaced with testfile.84.gz
testfile.85:     44.9% -- replaced with testfile.85.gz
testfile.86:     43.9% -- replaced with testfile.86.gz
testfile.87:     47.9% -- replaced with testfile.87.gz
testfile.88:     87.4% -- replaced with testfile.88.gz
testfile.89:     88.4% -- replaced with testfile.89.gz
testfile.90:     89.4% -- replaced with testfile.90.gz
testfile.91:     90.4% -- replaced with testfile.91.gz
testfile.92:     91.4% -- replaced with testfile.92.gz
testfile.93:     92.4% -- replaced with testfile.93.gz
testfile.94:     93.4% -- replaced with testfile.94.gz
testfile.95:     94.4% -- replaced with testfile.95.gz
testfile.96:     95.4% -- replaced with testfile.96.gz
testfile.97:     96.4% -- replaced with testfile.97.gz
testfile.98:     97.4% -- replaced with testfile.98.gz
testfile.99:     98.4% -- replaced with testfile.99.gz
testfile.100:     99.9% -- replaced with testfile.100.gz
