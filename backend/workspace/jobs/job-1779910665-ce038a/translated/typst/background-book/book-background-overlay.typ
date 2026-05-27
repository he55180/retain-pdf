#set text(font: "Source Han Sans SC", size: 11.4pt)
#import "@preview/cmarker:0.1.8"
#import "@preview/mitex:0.2.6": mitex
#show math.equation.where(block: false): set math.frac(style: "horizontal")
#let pdftr_fit_size(lo, hi, eps, fits) = {
  if hi - lo <= eps {
    lo
  } else {
    let mid = lo + (hi - lo) / 2
    if fits(mid) {
      pdftr_fit_size(mid, hi, eps, fits)
    } else {
      pdftr_fit_size(lo, mid, eps, fits)
    }
  }
}
#let pdftr_fit_single_line_markdown(markdown, max_size: 10pt, min_size: 9pt, fit_width: none, fit_height: none, weight: "regular", eps: 0.08pt) = {
  layout(size => {
    let allowed-width = if fit_width == none { size.width } else { calc.min(size.width, fit_width) }
    let allowed-height = if fit_height == none { size.height } else { calc.min(size.height, fit_height) }
    let render(text_size) = box(inset: 0pt, clip: false)[#{
      set text(size: text_size, weight: weight)
      set par(leading: 1em)
      cmarker.render(markdown, math: mitex)
    }]
    let fits(text_size) = {
      let measured = measure(render(text_size))
      measured.width <= allowed-width and measured.height <= allowed-height
    }
    let chosen-size = if fits(max_size) {
      max_size
    } else {
      pdftr_fit_size(min_size, max_size, eps, size_pt => fits(size_pt))
    }
    box(width: allowed-width, height: allowed-height, inset: 0pt, clip: false)[#{
      set text(size: chosen-size, weight: weight)
      set par(leading: 1em)
      cmarker.render(markdown, math: mitex)
    }]
  })
}
#let pdftr_fit_markdown(markdown, max_size: 10pt, min_size: 9pt, max_leading: 0.66em, min_leading: 0.54em, fit_height: none, eps: 0.08pt) = {
  layout(size => {
    let allowed-height = if fit_height == none { size.height } else { calc.min(size.height, fit_height) }
    let render(text_size, leading) = block(width: size.width)[#{
      set text(size: text_size)
      set par(leading: leading)
      cmarker.render(markdown, math: mitex)
    }]
    let fits(text_size, leading) = measure(width: size.width, render(text_size, leading)).height <= allowed-height
    if fits(max_size, max_leading) {
      render(max_size, max_leading)
    } else {
      let chosen-size = pdftr_fit_size(min_size, max_size, eps, size_pt => fits(size_pt, min_leading))
      render(chosen-size, min_leading)
    }
  })
}
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 1, width: 595.3200073242188pt))
#let rp0_item_p001_b002_0_md = "达累斯萨拉姆海上门户项目（DMGP）"
#let rp0_item_p001_b002_0_body = block(width: 281.44pt, height: 10.44pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b002_0_md, max_size: 9.56pt, min_size: 7.36pt, fit_width: 281.44pt, fit_height: 10.44pt, weight: "bold") }]
#context {
  place(top + left, dx: 168.8136135974061pt, dy: 88.91710198324577pt, rp0_item_p001_b002_0_body)
}
#let rp0_item_p001_b004_1_md = "达累斯萨拉姆港RORO及1-7号泊位混凝土损伤修复"
#let rp0_item_p001_b004_1_body = block(width: 454.82pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b004_1_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 454.82pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 86.15890020458652pt, dy: 115.05810874192267pt, rp0_item_p001_b004_1_body)
}
#let rp0_item_p001_b005_2_md = "第15次周例会纪要"
#let rp0_item_p001_b005_2_body = block(width: 176.31pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b005_2_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 176.31pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 222.33874669828973pt, dy: 149.25810199192267pt, rp0_item_p001_b005_2_body)
}
#let rp0_item_p001_b006_3_md = "参考："
#let rp0_item_p001_b006_3_body = block(width: 56.99915439927246pt, height: 9.150320080243148pt)[#{ pdftr_fit_markdown(rp0_item_p001_b006_3_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080243148pt) }]
#context {
  place(top + left, dx: 63.539978497349274pt, dy: 177.07810949192262pt, rp0_item_p001_b006_3_body)
}
#let rp0_item_p001_b007_4_md = "会议记录-第15次周会/2026年5月14日"
#let rp0_item_p001_b007_4_body = block(width: 133.57135698572745pt, height: 9.150320080243148pt)[#{ pdftr_fit_markdown(rp0_item_p001_b007_4_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080243148pt) }]
#context {
  place(top + left, dx: 413.41179920412173pt, dy: 177.07810949192262pt, rp0_item_p001_b007_4_body)
}
#let rp0_item_p001_b009_5_md = "日期/开始时间："
#let rp0_item_p001_b009_5_body = block(width: 80.19603257840343pt, height: 9.150320080243148pt)[#{ pdftr_fit_markdown(rp0_item_p001_b009_5_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080243148pt) }]
#context {
  place(top + left, dx: 64.15042265995798pt, dy: 212.35810499192254pt, rp0_item_p001_b009_5_body)
}
#let rp0_item_p001_b010_6_md = "2026年5月14日（星期四）/ 14:35"
#let rp0_item_p001_b010_6_body = block(width: 164.8341090412793pt, height: 10.139392678504976pt)[#{ pdftr_fit_markdown(rp0_item_p001_b010_6_md, max_size: 9.74pt, min_size: 7.54pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 10.139392678504976pt) }]
#context {
  place(top + left, dx: 257.77774946161264pt, dy: 211.34004031867565pt, rp0_item_p001_b010_6_body)
}
#let rp0_item_p001_b011_7_md = "地点："
#let rp0_item_p001_b011_7_body = block(width: 34.8303060073097pt, height: 9.150320080243148pt)[#{ pdftr_fit_markdown(rp0_item_p001_b011_7_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080243148pt) }]
#context {
  place(top + left, dx: 62.956587750192355pt, dy: 229.51810874192265pt, rp0_item_p001_b011_7_body)
}
#let rp0_item_p001_b012_8_md = "承包商现场营地办公室会议室，达累斯萨拉姆"
#let rp0_item_p001_b012_8_body = block(width: 242.80484324928233pt, height: 22.924709975704957pt)[#{ pdftr_fit_markdown(rp0_item_p001_b012_8_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.75em, min_leading: 0.67em, fit_height: 22.924709975704957pt) }]
#context {
  place(top + left, dx: 259.82961088813903pt, dy: 229.9466764800757pt, rp0_item_p001_b012_8_body)
}
#let rp0_item_p001_b013_9_md = "参会人员："
#let rp0_item_p001_b013_9_body = block(width: 54.08865674630872pt, height: 9.150320080242977pt)[#{ pdftr_fit_markdown(rp0_item_p001_b013_9_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080242977pt) }]
#context {
  place(top + left, dx: 63.46338645385023pt, dy: 261.3181042419227pt, rp0_item_p001_b013_9_body)
}
#let rp0_item_p001_b014_10_md = "见附件清单"
#let rp0_item_p001_b014_10_body = block(width: 77.43515889899413pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp0_item_p001_b014_10_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 255.47777708944722pt, dy: 261.3074722275757pt, rp0_item_p001_b014_10_body)
}
#let rp0_item_p001_b016_11_md = "分发名单"
#let rp0_item_p001_b016_11_body = block(width: 80.18578995769028pt, height: 9.150320080243091pt)[#{ pdftr_fit_markdown(rp0_item_p001_b016_11_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080243091pt) }]
#context {
  place(top + left, dx: 64.15015311730764pt, dy: 296.59811024192265pt, rp0_item_p001_b016_11_body)
}
#let rp0_item_p001_b017_12_md = "姓名"
#let rp0_item_p001_b017_12_body = block(width: 28.50049903277346pt, height: 9.150320080243091pt)[#{ pdftr_fit_markdown(rp0_item_p001_b017_12_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080243091pt) }]
#context {
  place(top + left, dx: 290.3908313227423pt, dy: 296.59811024192265pt, rp0_item_p001_b017_12_body)
}
#let rp0_item_p001_b018_13_md = "电子邮件"
#let rp0_item_p001_b018_13_body = block(width: 31.384652713593823pt, height: 9.150320080243091pt)[#{ pdftr_fit_markdown(rp0_item_p001_b018_13_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080243091pt) }]
#context {
  place(top + left, dx: 441.4722693477876pt, dy: 296.59811024192265pt, rp0_item_p001_b018_13_body)
}
#let rp0_item_p001_b019_14_md = "TPA局长"
#let rp0_item_p001_b019_14_body = block(width: 108.63720643264145pt, height: 9.16311773070504pt)[#{ pdftr_fit_markdown(rp0_item_p001_b019_14_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.16311773070504pt) }]
#context {
  place(top + left, dx: 64.89887460349055pt, dy: 313.74748197757566pt, rp0_item_p001_b019_14_body)
}
#let rp0_item_p001_b022_15_md = "项目工程师 (PE) - TPA"
#let rp0_item_p001_b022_15_body = block(width: 132.92119373922364pt, height: 9.163117730704982pt)[#{ pdftr_fit_markdown(rp0_item_p001_b022_15_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704982pt) }]
#context {
  place(top + left, dx: 65.5379269010322pt, dy: 330.9074624775757pt, rp0_item_p001_b022_15_body)
}
#let rp0_item_p001_b025_16_md = "工程师 (En) - INROS LACKNER"
#let rp0_item_p001_b025_16_body = block(width: 161.37252826809083pt, height: 9.163117730704982pt)[#{ pdftr_fit_markdown(rp0_item_p001_b025_16_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704982pt) }]
#context {
  place(top + left, dx: 66.28664623073922pt, dy: 348.06746622757566pt, rp0_item_p001_b025_16_body)
}
#let rp0_item_p001_b028_17_md = "承包商代表 - CHEC"
#let rp0_item_p001_b028_17_body = block(width: 170.79306177544925pt, height: 9.163117730704982pt)[#{ pdftr_fit_markdown(rp0_item_p001_b028_17_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704982pt) }]
#context {
  place(top + left, dx: 66.53455500724866pt, dy: 365.2274699775757pt, rp0_item_p001_b028_17_body)
}
#let rp0_item_p001_b031_18_md = "0. 会议议程"
#let rp0_item_p001_b031_18_body = block(width: 148.95pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b031_18_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 148.95pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 60.37310058025943pt, dy: 392.9780839919227pt, rp0_item_p001_b031_18_body)
}
#let rp0_item_p001_b032_19_md = "会议开幕"
#let rp0_item_p001_b032_19_body = block(width: 116.93485816281729pt, height: 9.16311773070504pt)[#{ pdftr_fit_markdown(rp0_item_p001_b032_19_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.16311773070504pt) }]
#context {
  place(top + left, dx: 82.39723460954782pt, dy: 418.86748497757566pt, rp0_item_p001_b032_19_body)
}
#let rp0_item_p001_b033_20_md = "承包商开工准备情况"
#let rp0_item_p001_b033_20_body = block(width: 213.94543785174267pt, height: 9.16311773070504pt)[#{ pdftr_fit_markdown(rp0_item_p001_b033_20_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.16311773070504pt) }]
#context {
  place(top + left, dx: 84.95014460136166pt, dy: 432.5474774775757pt, rp0_item_p001_b033_20_body)
}
#let rp0_item_p001_b034_21_md = "合同事项"
#let rp0_item_p001_b034_21_body = block(width: 105.91914134269014pt, height: 9.163117730704982pt)[#{ pdftr_fit_markdown(rp0_item_p001_b034_21_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704982pt) }]
#context {
  place(top + left, dx: 82.10734732480763pt, dy: 445.9874647275757pt, rp0_item_p001_b034_21_body)
}
#let rp0_item_p001_b035_22_md = "施工方案"
#let rp0_item_p001_b035_22_body = block(width: 162.76572738442357pt, height: 9.16311773070504pt)[#{ pdftr_fit_markdown(rp0_item_p001_b035_22_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.16311773070504pt) }]
#context {
  place(top + left, dx: 106.88331086537957pt, dy: 458.70748122757567pt, rp0_item_p001_b035_22_body)
}
#let rp0_item_p001_b036_23_md = "劳工、材料与设备"
#let rp0_item_p001_b036_23_body = block(width: 195.91202624003893pt, height: 9.163117730704982pt)[#{ pdftr_fit_markdown(rp0_item_p001_b036_23_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704982pt) }]
#context {
  place(top + left, dx: 107.75558188789576pt, dy: 471.30747222757566pt, rp0_item_p001_b036_23_body)
}
#let rp0_item_p001_b037_24_md = "项目经理设施"
#let rp0_item_p001_b037_24_body = block(width: 79.15616234249994pt, height: 9.163117730704982pt)[#{ pdftr_fit_markdown(rp0_item_p001_b037_24_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704982pt) }]
#context {
  place(top + left, dx: 104.68305915375pt, dy: 484.02748872757576pt, rp0_item_p001_b037_24_body)
}
#let rp0_item_p001_b038_25_md = "日报、周报和月报"
#let rp0_item_p001_b038_25_body = block(width: 177.3167817448533pt, height: 9.163117730704982pt)[#{ pdftr_fit_markdown(rp0_item_p001_b038_25_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704982pt) }]
#context {
  place(top + left, dx: 107.26623334854878pt, dy: 496.6274789775757pt, rp0_item_p001_b038_25_body)
}
#let rp0_item_p001_b039_26_md = "4. 其他事项"
#let rp0_item_p001_b039_26_body = block(width: 44.12pt, height: 9.62pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b039_26_md, max_size: 8.8pt, min_size: 7.2pt, fit_width: 44.12pt, fit_height: 9.62pt, weight: "bold") }]
#context {
  place(top + left, dx: 80.42584042875pt, dy: 508.76746997757573pt, rp0_item_p001_b039_26_body)
}
#let rp0_item_p001_b040_27_md = "新缺陷"
#let rp0_item_p001_b040_27_body = block(width: 79.32557503149889pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp0_item_p001_b040_27_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 104.56751438240786pt, dy: 521.9474864775757pt, rp0_item_p001_b040_27_body)
}
#let rp0_item_p001_b041_28_md = "卸料区"
#let rp0_item_p001_b041_28_body = block(width: 86.84569561340334pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp0_item_p001_b041_28_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 104.76541229245797pt, dy: 534.5474774775757pt, rp0_item_p001_b041_28_body)
}
#let rp0_item_p001_b042_29_md = "急救设施"
#let rp0_item_p001_b042_29_body = block(width: 101.8830688320848pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp0_item_p001_b042_29_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 105.16113264031802pt, dy: 547.2674939775757pt, rp0_item_p001_b042_29_body)
}
#let rp0_item_p001_b043_30_md = "维修与办公空间"
#let rp0_item_p001_b043_30_body = block(width: 162.95419133704095pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp0_item_p001_b043_30_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 106.76826744308002pt, dy: 559.8674849775757pt, rp0_item_p001_b043_30_body)
}
#let rp0_item_p001_b044_31_md = "预制构件与存储区域"
#let rp0_item_p001_b044_31_body = block(width: 201.85458076351983pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp0_item_p001_b044_31_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 107.79196190167157pt, dy: 572.5874557275757pt, rp0_item_p001_b044_31_body)
}
#let rp0_item_p001_b045_32_md = "集装箱堆场照明"
#let rp0_item_p001_b045_32_body = block(width: 204.7817124541698pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp0_item_p001_b045_32_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 107.86899168300447pt, dy: 585.1874917275758pt, rp0_item_p001_b045_32_body)
}
#let rp0_item_p001_b046_33_md = "承包商发票"
#let rp0_item_p001_b046_33_body = block(width: 120.46581735181624pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp0_item_p001_b046_33_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 105.65015233820569pt, dy: 597.7874827275757pt, rp0_item_p001_b046_33_body)
}
#let rp0_item_p001_b047_34_md = "会议闭幕"
#let rp0_item_p001_b047_34_body = block(width: 125.04249455591288pt, height: 9.163117730704812pt)[#{ pdftr_fit_markdown(rp0_item_p001_b047_34_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704812pt) }]
#context {
  place(top + left, dx: 82.61059346199771pt, dy: 610.5074534775758pt, rp0_item_p001_b047_34_body)
}
#let rp0_item_p001_b048_35_md = "1. 会议开幕"
#let rp0_item_p001_b048_35_body = block(width: 139.85pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp0_item_p001_b048_35_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 139.85pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 60.14497620375848pt, dy: 647.3780929919227pt, rp0_item_p001_b048_35_body)
}
#let rp0_item_p001_b049_36_md = "驻地工程师 - RE（IL - Eng. José Rodrigues）宣布会议开始，并向与会成员表示欢迎。本次会议由驻地工程师代表工程师主持。"
#let rp0_item_p001_b049_36_body = block(width: 433.8114811487851pt, height: 21.007152275704925pt)[#{ pdftr_fit_markdown(rp0_item_p001_b049_36_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.68em, min_leading: 0.6em, fit_height: 21.007152275704925pt) }]
#context {
  place(top + left, dx: 96.37609085917856pt, dy: 666.8054530800757pt, rp0_item_p001_b049_36_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 2, width: 595.3200073242188pt))
#let rp1_item_p002_b002_0_md = "达累斯萨拉姆海上门户项目（DMGP）"
#let rp1_item_p002_b002_0_body = block(width: 281.44pt, height: 10.44pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b002_0_md, max_size: 9.56pt, min_size: 7.36pt, fit_width: 281.44pt, fit_height: 10.44pt, weight: "bold") }]
#context {
  place(top + left, dx: 168.8136135974061pt, dy: 88.91710198324577pt, rp1_item_p002_b002_0_body)
}
#let rp1_item_p002_b004_1_md = "达累斯萨拉姆港RORO及1-7号泊位混凝土损伤修复"
#let rp1_item_p002_b004_1_body = block(width: 454.82pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp1_item_p002_b004_1_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 454.82pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 86.15890020458652pt, dy: 115.05810874192267pt, rp1_item_p002_b004_1_body)
}
#let rp1_item_p002_b010_2_md = "承包商开工准备情况"
#let rp1_item_p002_b010_2_body = block(width: 204.20449732989073pt, height: 14.883621167391539pt)[#{ pdftr_fit_markdown(rp1_item_p002_b010_2_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.883621167391539pt) }]
#context {
  place(top + left, dx: 116.61321793869138pt, dy: 166.8056062143296pt, rp1_item_p002_b010_2_body)
}
#let rp1_item_p002_b011_3_md = "关于现场交通可达性，驻地工程师在会上通报，正如2026年5月12日三方会议上所报告的，目前在港区内获得施工场地仍然困难。尽管如此，业主承诺将继续与DP World保持跟进，在条件有利时为承包商分配场地。随后，会议同意TPA将与DP World协调，提前为承包商的工人办理港区通行证，以便在情况允许开工时方便进入。"
#let rp1_item_p002_b011_3_body = block(width: 323.84684201329947pt, height: 114.45554787218569pt)[#{ pdftr_fit_markdown(rp1_item_p002_b011_3_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 114.45554787218569pt) }]
#context {
  place(top + left, dx: 113.11003810539842pt, dy: 186.3722868695855pt, rp1_item_p002_b011_3_body)
}
#let rp1_item_p002_b012_4_md = "关于铺路块，承包商被要求提供代表性样品及来源于实际生产（用于现场施工）的经核实的试验结果。承包商在会议上告知，他无法找到一家信誉良好的"
#let rp1_item_p002_b012_4_body = block(width: 319.47870164960625pt, height: 78.90038146156074pt)[#{ pdftr_fit_markdown(rp1_item_p002_b012_4_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 78.90038146156074pt) }]
#context {
  place(top + left, dx: 116.7330998338759pt, dy: 253.15446044847369pt, rp1_item_p002_b012_4_body)
}
#let rp1_item_p002_b013_5_md = "国内的实验室能够进行抗滑试验，因此请求驻地工程师协助在坦桑尼亚寻找一家实验室进行所述试验。"
#let rp1_item_p002_b013_5_body = block(width: 322.89083288908pt, height: 45.58306749820713pt)[#{ pdftr_fit_markdown(rp1_item_p002_b013_5_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 45.58306749820713pt) }]
#context {
  place(top + left, dx: 114.83075625300407pt, dy: 377.868909430027pt, rp1_item_p002_b013_5_body)
}
#let rp1_item_p002_b014_6_md = "驻地工程师已承诺调查该问题并会据此提供建议。与此同时，工程师正在分析承包商提交的劈裂抗拉试验结果，并将在不久后给出答复。"
#let rp1_item_p002_b014_6_body = block(width: 325.6106064513326pt, height: 47.809647092819205pt)[#{ pdftr_fit_markdown(rp1_item_p002_b014_6_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 47.809647092819205pt) }]
#context {
  place(top + left, dx: 114.13091826960445pt, dy: 429.01692851138114pt, rp1_item_p002_b014_6_body)
}
#let rp1_item_p002_b015_7_md = "信息"
#let rp1_item_p002_b015_7_body = block(width: 31.382359832525253pt, height: 15.386403315365328pt)[#{ pdftr_fit_markdown(rp1_item_p002_b015_7_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.386403315365328pt) }]
#context {
  place(top + left, dx: 483.2007413059473pt, dy: 201.9183751900494pt, rp1_item_p002_b015_7_body)
}
#let rp1_item_p002_b017_8_md = "信息"
#let rp1_item_p002_b017_8_body = block(width: 31.69473972916603pt, height: 15.68180924773219pt)[#{ pdftr_fit_markdown(rp1_item_p002_b017_8_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.68180924773219pt) }]
#context {
  place(top + left, dx: 483.186477586627pt, dy: 343.46676480710505pt, rp1_item_p002_b017_8_body)
}
#let rp1_item_p002_b020_9_md = "合同事项"
#let rp1_item_p002_b020_9_body = block(width: 97.52413131892682pt, height: 14.628606791496281pt)[#{ pdftr_fit_markdown(rp1_item_p002_b020_9_md, max_size: 14.05pt, min_size: 11.85pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.628606791496281pt) }]
#context {
  place(top + left, dx: 108.33830298930407pt, dy: 485.8167598195076pt, rp1_item_p002_b020_9_body)
}
#let rp1_item_p002_b022_10_md = "劳工、材料和设备"
#let rp1_item_p002_b022_10_body = block(width: 196.3035373315215pt, height: 14.730808134078984pt)[#{ pdftr_fit_markdown(rp1_item_p002_b022_10_md, max_size: 14.15pt, min_size: 11.95pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.730808134078984pt) }]
#context {
  place(top + left, dx: 110.44966930523515pt, dy: 504.8062454111576pt, rp1_item_p002_b022_10_body)
}
#let rp1_item_p002_b023_11_md = "驻地工程师再次提醒承包商，要求其按照合同中批准的员工名单提交所有员工（包括本地和外国员工）的名单。"
#let rp1_item_p002_b023_11_body = block(width: 321.9701423928142pt, height: 36.89545999288555pt)[#{ pdftr_fit_markdown(rp1_item_p002_b023_11_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 36.89545999288555pt) }]
#context {
  place(top + left, dx: 114.88747379258275pt, dy: 524.4264999933243pt, rp1_item_p002_b023_11_body)
}
#let rp1_item_p002_b024_12_md = "关于外籍员工，驻地工程师提醒承包商提交护照入境许可副本，以证明其获准进入该国并在该国工作。承包商承诺在2026年5月21日下次会议前提交。"
#let rp1_item_p002_b024_12_body = block(width: 322.38400354236364pt, height: 29.377478638172178pt)[#{ pdftr_fit_markdown(rp1_item_p002_b024_12_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 29.377478638172178pt) }]
#context {
  place(top + left, dx: 114.70213875547051pt, dy: 566.5286692447662pt, rp1_item_p002_b024_12_body)
}
#let rp1_item_p002_b025_13_md = "关于已进场的设备，驻地工程师询问有缺陷的压缩机是否已修复。承包商告知会议，他仍在等待从中国订购的备件，预计将于2026年5月底前到达。"
#let rp1_item_p002_b025_13_body = block(width: 324.9979056477547pt, height: 40.9006447725295pt)[#{ pdftr_fit_markdown(rp1_item_p002_b025_13_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 40.9006447725295pt) }]
#context {
  place(top + left, dx: 113.44887290596962pt, dy: 640.6474496939182pt, rp1_item_p002_b025_13_body)
}
#let rp1_item_p002_b026_14_md = "关于混凝土配合比设计，承包商已提交28天试验结果，工程师正在核查并将相应回复。"
#let rp1_item_p002_b026_14_body = block(width: 321.05247719734905pt, height: 27.050792322158713pt)[#{ pdftr_fit_markdown(rp1_item_p002_b026_14_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 27.050792322158713pt) }]
#context {
  place(top + left, dx: 114.78263027146458pt, dy: 725.5579488418102pt, rp1_item_p002_b026_14_body)
}
#let rp1_item_p002_b032_15_md = "PM 设施"
#let rp1_item_p002_b032_15_body = block(width: 66.58909386992455pt, height: 15.064830315113113pt)[#{ pdftr_fit_markdown(rp1_item_p002_b032_15_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.064830315113113pt) }]
#context {
  place(top + left, dx: 105.81667959392071pt, dy: 755.7276584515571pt, rp1_item_p002_b032_15_body)
}
#let rp1_item_p002_b033_16_md = "驻地工程师告知会议，TPA方面无最新进展。"
#let rp1_item_p002_b033_16_body = block(width: 307.6704038485884pt, height: 8.822366440296264pt)[#{ pdftr_fit_markdown(rp1_item_p002_b033_16_md, max_size: 11.74pt, min_size: 10.94pt, max_leading: 0.59em, min_leading: 0.51em, fit_height: 8.822366440296264pt) }]
#context {
  place(top + left, dx: 112.18370507135987pt, dy: 775.9448760995864pt, rp1_item_p002_b033_16_body)
}
#let rp1_item_p002_b036_17_md = "日报、周报和月报"
#let rp1_item_p002_b036_17_body = block(width: 175.87339256480334pt, height: 14.871282117366718pt)[#{ pdftr_fit_markdown(rp1_item_p002_b036_17_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 14.871282117366718pt) }]
#context {
  place(top + left, dx: 109.39592574648559pt, dy: 794.7024831161499pt, rp1_item_p002_b036_17_body)
}
#let rp1_item_p002_b037_18_md = "驻地工程师告知会议，根据合同要求，现正按相应方式接收承包商的报告。每周报告应按周提交，周期为周一至周日。"
#let rp1_item_p002_b037_18_body = block(width: 321.14613488167527pt, height: 52.39792350530615pt)[#{ pdftr_fit_markdown(rp1_item_p002_b037_18_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 52.39792350530615pt) }]
#context {
  place(top + left, dx: 115.00561234429479pt, dy: 814.8177378664017pt, rp1_item_p002_b037_18_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 3, width: 595.3200073242188pt))
#let rp2_item_p003_b002_0_md = "达累斯萨拉姆海上门户项目（DMGP）"
#let rp2_item_p003_b002_0_body = block(width: 281.44pt, height: 10.44pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p003_b002_0_md, max_size: 9.56pt, min_size: 7.36pt, fit_width: 281.44pt, fit_height: 10.44pt, weight: "bold") }]
#context {
  place(top + left, dx: 168.8136135974061pt, dy: 88.91710198324577pt, rp2_item_p003_b002_0_body)
}
#let rp2_item_p003_b004_1_md = "达累斯萨拉姆港RORO及1-7号泊位混凝土损伤修复"
#let rp2_item_p003_b004_1_body = block(width: 454.82pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp2_item_p003_b004_1_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 454.82pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 86.15890020458652pt, dy: 115.05810874192267pt, rp2_item_p003_b004_1_body)
}
#let rp2_item_p003_b007_2_md = "其他事项"
#let rp2_item_p003_b007_2_body = block(width: 29.13003042191268pt, height: 9.52708522254602pt)[#{ pdftr_fit_markdown(rp2_item_p003_b007_2_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 9.52708522254602pt) }]
#context {
  place(top + left, dx: 105.85322204306722pt, dy: 148.75651085597462pt, rp2_item_p003_b007_2_body)
}
#let rp2_item_p003_b009_3_md = "新缺陷"
#let rp2_item_p003_b009_3_body = block(width: 68.05911215357482pt, height: 15.437361730635189pt)[#{ pdftr_fit_markdown(rp2_item_p003_b009_3_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.437361730635189pt) }]
#context {
  place(top + left, dx: 106.25188605505973pt, dy: 166.98038857504724pt, rp2_item_p003_b009_3_body)
}
#let rp2_item_p003_b010_4_md = "关于新缺陷，驻地工程师告知会议，业主对于建议的与所有各方联合检查以确定与合同已识别裂缝相关的新裂缝，尚无最新进展。"
#let rp2_item_p003_b010_4_body = block(width: 322.9605133056641pt, height: 51.046613351851704pt)[#{ pdftr_fit_markdown(rp2_item_p003_b010_4_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 51.046613351851704pt) }]
#context {
  place(top + left, dx: 114.4664433836937pt, dy: 188.69048536874354pt, rp2_item_p003_b010_4_body)
}
#let rp2_item_p003_b013_5_md = "倾倒区"
#let rp2_item_p003_b013_5_body = block(width: 76.0688070911914pt, height: 15.04623800218107pt)[#{ pdftr_fit_markdown(rp2_item_p003_b013_5_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.04623800218107pt) }]
#context {
  place(top + left, dx: 107.49240287225693pt, dy: 245.132988871634pt, rp2_item_p003_b013_5_body)
}
#let rp2_item_p003_b014_6_md = "关于弃土区，承包商仍在等待TPA的正式通知。"
#let rp2_item_p003_b014_6_body = block(width: 321.58075100183487pt, height: 9.82944337933067pt)[#{ pdftr_fit_markdown(rp2_item_p003_b014_6_md, max_size: 11.72pt, min_size: 10.92pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 9.82944337933067pt) }]
#context {
  place(top + left, dx: 114.46120890974998pt, dy: 265.27294997543095pt, rp2_item_p003_b014_6_body)
}
#let rp2_item_p003_b017_7_md = "急救设施"
#let rp2_item_p003_b017_7_body = block(width: 93.18102356046438pt, height: 15.220771475136303pt)[#{ pdftr_fit_markdown(rp2_item_p003_b017_7_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.220771475136303pt) }]
#context {
  place(top + left, dx: 108.1508850492537pt, dy: 317.81458319054246pt, rp2_item_p003_b017_7_body)
}
#let rp2_item_p003_b018_8_md = "第三间急救室容器已于4月10日在供应商处经承包商与工程师联合检查，确认其满足要求。承包商在会上通报，待收到中国方面的资金后，将安排该容器的制造与运输，预计于2026年5月底前运抵现场。"
#let rp2_item_p003_b018_8_body = block(width: 326.39209089726205pt, height: 72.33897312998772pt)[#{ pdftr_fit_markdown(rp2_item_p003_b018_8_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 72.33897312998772pt) }]
#context {
  place(top + left, dx: 114.01281600669026pt, dy: 338.71457038314344pt, rp2_item_p003_b018_8_body)
}
#let rp2_item_p003_b021_9_md = "维护与办公空间"
#let rp2_item_p003_b021_9_body = block(width: 151.7419963002205pt, height: 15.025727165937383pt)[#{ pdftr_fit_markdown(rp2_item_p003_b021_9_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.025727165937383pt) }]
#context {
  place(top + left, dx: 109.75719424486161pt, dy: 421.85158602983955pt, rp2_item_p003_b021_9_body)
}
#let rp2_item_p003_b022_10_md = "驻地工程师向会议通报称，观察到周边环境有明显改善，即便在近期的降雨期间也未闻到异味。"
#let rp2_item_p003_b022_10_body = block(width: 321.0083640903234pt, height: 41.46337743401523pt)[#{ pdftr_fit_markdown(rp2_item_p003_b022_10_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 41.46337743401523pt) }]
#context {
  place(top + left, dx: 114.02824726253748pt, dy: 442.0763284400225pt, rp2_item_p003_b022_10_body)
}
#let rp2_item_p003_b025_11_md = "预制构件与存储区域"
#let rp2_item_p003_b025_11_body = block(width: 184.0253892093897pt, height: 8.85993558883672pt)[#{ pdftr_fit_markdown(rp2_item_p003_b025_11_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.85993558883672pt) }]
#context {
  place(top + left, dx: 110.32641514390707pt, dy: 487.6153148600578pt, rp2_item_p003_b025_11_body)
}
#let rp2_item_p003_b026_12_md = "关于港口内预制构件的存放空间要求，承包商告知会议，其已决定从港口外采购预制构件，因此此前讨论中获取港口内空间的紧迫性已不再必要。"
#let rp2_item_p003_b026_12_body = block(width: 322.3358660817146pt, height: 66.9480653715134pt)[#{ pdftr_fit_markdown(rp2_item_p003_b026_12_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 66.9480653715134pt) }]
#context {
  place(top + left, dx: 114.30627203583717pt, dy: 505.6366975376129pt, rp2_item_p003_b026_12_body)
}
#let rp2_item_p003_b027_13_md = "驻地工程师再次指示承包商以书面形式确认不再需要使用上述设施。承包商承诺在2026年5月21日下次会议前提交书面确认。"
#let rp2_item_p003_b027_13_body = block(width: 324.24563294351105pt, height: 54.767397129535766pt)[#{ pdftr_fit_markdown(rp2_item_p003_b027_13_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 54.767397129535766pt) }]
#context {
  place(top + left, dx: 114.57811290174723pt, dy: 567.4045021638393pt, rp2_item_p003_b027_13_body)
}
#let rp2_item_p003_b028_14_md = "信息"
#let rp2_item_p003_b028_14_body = block(width: 32.04916427135464pt, height: 15.692407629489935pt)[#{ pdftr_fit_markdown(rp2_item_p003_b028_14_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.692407629489935pt) }]
#context {
  place(top + left, dx: 483.05464853048323pt, dy: 500.89881556153296pt, rp2_item_p003_b028_14_body)
}
#let rp2_item_p003_b031_15_md = "港口集装箱堆场照明"
#let rp2_item_p003_b031_15_body = block(width: 206.67609069272874pt, height: 15.292837750911758pt)[#{ pdftr_fit_markdown(rp2_item_p003_b031_15_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.292837750911758pt) }]
#context {
  place(top + left, dx: 110.48236236460507pt, dy: 631.3572621807575pt, rp2_item_p003_b031_15_body)
}
#let rp2_item_p003_b032_16_md = "承包商提交了建议采用410瓦照明的方案，但驻地工程师表示设计要求为1000瓦。驻地工程师告知，我方已收到承包商提交的港口照明装置支持文件；将对其进行审核，并给予承包商相应回复。"
#let rp2_item_p003_b032_16_body = block(width: 323.5913518428803pt, height: 48.25544883298868pt)[#{ pdftr_fit_markdown(rp2_item_p003_b032_16_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 48.25544883298868pt) }]
#context {
  place(top + left, dx: 111.95159710645676pt, dy: 652.0725753197194pt, rp2_item_p003_b032_16_body)
}
#let rp2_item_p003_b035_17_md = "承包商发票"
#let rp2_item_p003_b035_17_body = block(width: 114.49790861643851pt, height: 15.294229495525315pt)[#{ pdftr_fit_markdown(rp2_item_p003_b035_17_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 15.294229495525315pt) }]
#context {
  place(top + left, dx: 107.04278207477182pt, dy: 744.1973968653202pt, rp2_item_p003_b035_17_body)
}
#let rp2_item_p003_b036_18_md = "驻地工程师建议承包商核实，当前已花费金额是否低于或高于合同规定的开票所需最低金额（即2%）。"
#let rp2_item_p003_b036_18_body = block(width: 320.28137727230785pt, height: 40.638873131275204pt)[#{ pdftr_fit_markdown(rp2_item_p003_b036_18_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.76em, min_leading: 0.68em, fit_height: 40.638873131275204pt) }]
#context {
  place(top + left, dx: 114.57902789786458pt, dy: 766.269239037466pt, rp2_item_p003_b036_18_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 4, width: 595.3200073242188pt))
#let rp3_item_p004_b002_0_md = "达累斯萨拉姆海上门户项目（DMGP）"
#let rp3_item_p004_b002_0_body = block(width: 281.44pt, height: 10.44pt)[#{ pdftr_fit_single_line_markdown(rp3_item_p004_b002_0_md, max_size: 9.56pt, min_size: 7.36pt, fit_width: 281.44pt, fit_height: 10.44pt, weight: "bold") }]
#context {
  place(top + left, dx: 168.8136135974061pt, dy: 88.91710198324577pt, rp3_item_p004_b002_0_body)
}
#let rp3_item_p004_b004_1_md = "达累斯萨拉姆港RORO及1-7号泊位混凝土损伤修复"
#let rp3_item_p004_b004_1_body = block(width: 454.82pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp3_item_p004_b004_1_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 454.82pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 86.15890020458652pt, dy: 115.05810874192267pt, rp3_item_p004_b004_1_body)
}
#let rp3_item_p004_b005_2_md = "下次会议：2026年5月21日（星期四）14:30"
#let rp3_item_p004_b005_2_body = block(width: 239.81333491281728pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp3_item_p004_b005_2_md, max_size: 10.65pt, min_size: 9.85pt, max_leading: 0.6em, min_leading: 0.52em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 62.95087498454783pt, dy: 202.14746847757573pt, rp3_item_p004_b005_2_body)
}
#let rp3_item_p004_b006_3_md = "签字人："
#let rp3_item_p004_b006_3_body = block(width: 53.401541831176885pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp3_item_p004_b006_3_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 58.045301482399395pt, dy: 240.06746622757572pt, rp3_item_p004_b006_3_body)
}
#let rp3_item_p004_b007_4_md = "工程师 Cheng Yongjian"
#let rp3_item_p004_b007_4_body = block(width: 101.67391485149427pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp3_item_p004_b007_4_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 65.07562708819721pt, dy: 267.90746247757573pt, rp3_item_p004_b007_4_body)
}
#let rp3_item_p004_b008_5_md = "副承包商代表"
#let rp3_item_p004_b008_5_body = block(width: 169.55165804132778pt, height: 9.163117730704926pt)[#{ pdftr_fit_markdown(rp3_item_p004_b008_5_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704926pt) }]
#context {
  place(top + left, dx: 66.86188348792967pt, dy: 285.0674662275757pt, rp3_item_p004_b008_5_body)
}
#let rp3_item_p004_b009_6_md = "致承包商 – CHEC"
#let rp3_item_p004_b009_6_body = block(width: 156.74778726730966pt, height: 9.150320080243091pt)[#{ pdftr_fit_markdown(rp3_item_p004_b009_6_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080243091pt) }]
#context {
  place(top + left, dx: 66.52493952019236pt, dy: 302.2381019919227pt, rp3_item_p004_b009_6_body)
}
#let rp3_item_p004_b011_7_md = "驻地工程师"
#let rp3_item_p004_b011_7_body = block(width: 88.93088513794926pt, height: 9.163117730704982pt)[#{ pdftr_fit_markdown(rp3_item_p004_b011_7_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.163117730704982pt) }]
#context {
  place(top + left, dx: 64.74028420099866pt, dy: 358.62747897757566pt, rp3_item_p004_b011_7_body)
}
#let rp3_item_p004_b012_8_md = "致：工程师 - IL"
#let rp3_item_p004_b012_8_body = block(width: 116.7325926885352pt, height: 9.150320080243034pt)[#{ pdftr_fit_markdown(rp3_item_p004_b012_8_md, max_size: 8.79pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.150320080243034pt) }]
#context {
  place(top + left, dx: 65.47190808390882pt, dy: 375.7981147419227pt, rp3_item_p004_b012_8_body)
}
#let rp3_item_p004_b013_9_md = "5.0 会议闭幕"
#let rp3_item_p004_b013_9_body = block(width: 147.34pt, height: 9.61pt)[#{ pdftr_fit_single_line_markdown(rp3_item_p004_b013_9_md, max_size: 8.79pt, min_size: 7.2pt, fit_width: 147.34pt, fit_height: 9.61pt, weight: "bold") }]
#context {
  place(top + left, dx: 84.81278392127506pt, dy: 153.21810049192266pt, rp3_item_p004_b013_9_body)
}
#let rp3_item_p004_b014_10_md = "由于无其他事项，会议于14:56宣布结束。"
#let rp3_item_p004_b014_10_body = block(width: 321.96080078425814pt, height: 21.007119845705006pt)[#{ pdftr_fit_markdown(rp3_item_p004_b014_10_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.69em, min_leading: 0.61em, fit_height: 21.007119845705006pt) }]
#context {
  place(top + left, dx: 115.63265640221734pt, dy: 173.2454730450757pt, rp3_item_p004_b014_10_body)
}
#let rp3_item_p004_b015_11_md = "全部"
#let rp3_item_p004_b015_11_body = block(width: 21.49398364549819pt, height: 9.16311773070504pt)[#{ pdftr_fit_markdown(rp3_item_p004_b015_11_md, max_size: 8.8pt, min_size: 7.2pt, max_leading: 0.29em, min_leading: 0.18em, fit_height: 9.16311773070504pt) }]
#context {
  place(top + left, dx: 491.36564914856575pt, dy: 172.8674729775757pt, rp3_item_p004_b015_11_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 5, width: 595.3200073242188pt))
#let rp4_item_p005_b003_0_md = "达累斯萨拉姆海上门户项目（DMGP）"
#let rp4_item_p005_b003_0_body = block(width: 281.44pt, height: 10.44pt)[#{ pdftr_fit_single_line_markdown(rp4_item_p005_b003_0_md, max_size: 9.56pt, min_size: 7.36pt, fit_width: 281.44pt, fit_height: 10.44pt, weight: "bold") }]
#context {
  place(top + left, dx: 168.8136135974061pt, dy: 88.91710198324577pt, rp4_item_p005_b003_0_body)
}
#let rp4_item_p005_b004_1_md = "合同编号: TZ-TPA-/424013-CW-DIR 达累斯萨拉姆港RORO和1-7号泊位混凝土损坏修复"
#let rp4_item_p005_b004_1_body = block(width: 454.82pt, height: 22.05pt)[#{ pdftr_fit_single_line_markdown(rp4_item_p005_b004_1_md, max_size: 19.32pt, min_size: 12.0pt, fit_width: 454.82pt, fit_height: 22.05pt, weight: "bold") }]
#context {
  place(top + left, dx: 86.15890020458652pt, dy: 102.23539732292268pt, rp4_item_p005_b004_1_body)
}
