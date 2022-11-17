import {v4 as UUID} from "uuid"
import { NavItem } from "./NavItem";






export function Nav({items, }:any) {
    return ( 
        <div className="w-[14.5rem] md:flex justify-between ">
         {   items &&
          items.map((item:any, idx:number) =>
          idx === 0 ? (
                <NavItem {...{ ...item, extraStyle: "mr-[3.31rem] " }} />
              ) : (
                  <NavItem { ...item} key={UUID()} />
            )
          )}
        </div>
     );
}