import { initFontDetector } from './javascripts/font-detector'
import hljs from "highlight.js/lib/common"
import { processBq } from "./javascripts/process_bq"
import { dialogFixes } from './javascripts/dialog-fixes'
import { amazonMicrocopy } from './javascripts/amazon-microcopy'

async function detectAll () {
  const detector = await initFontDetector
  if (detector.check('hiragino', 'Hiragino Sans')) {
    detector.check('w4', 'Hiragino Sans W4')
    detector.check('w5', 'Hiragino Sans W5')
  }
  detector.destroy()
}
detectAll()

hljs.highlightAll()
processBq()
dialogFixes()
amazonMicrocopy()
