/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
    webpack: (config) => {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        child_process: false,
        readline: false,
      };
      return config;
    }
}

module.exports = nextConfig
