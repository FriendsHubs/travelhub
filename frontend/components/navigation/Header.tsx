
export function Header({ children }: any) {
  const logo = children[0];
  const searchField = children[1];
  const navMenu = children[2];
  return (
    <div className="h-[96px] bg-black flex justify-between items-center pl-[40px] pr-[42px] ">
      <div className="w-[195px] h-[24px] mr-[223px]">{logo}</div>
      <div className="hidden lg:block w-[657px] h-[45px] mr-[41px] rounded-lg overflow-hidden">{searchField}</div>
      <div className="md:hidden block text-white">menu</div>
      <div className="hidden md:block text-white">{navMenu}</div>
    </div>
  );
}
