import { createClient } from "microcms-js-sdk"

export default async () => {
  const client = createClient({
    serviceDomain: process.env.MICROCMS_SERVICE_DOMAIN,
    apiKey: process.env.MICROCMS_API_KEY
  })
  // prepare query
  const now = new Date()
  const iso = now.toISOString()

  try {
    // get contents from microCMS API
    const res = await client.get({
      endpoint: 'amazon-sale',
      queries: {
        fields: 'copy',
        filters: `from[less_than]${iso}[and]to[greater_than]${iso}`
      }
    })
    return Response.json(res)
  } catch (err) {
    // error handling
    console.log(err)
    return Response.json({
      error: err.toString(),
      totalCount: -1
    })
  }
}
